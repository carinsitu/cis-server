require 'cisserver/network/tcpserver'
require 'cisserver/network/udpserver'

require 'async'
require 'dnssd'

module CisServer
  module Network
    class NodesMaster
      attr_writer :on_register
      attr_writer :on_reregister
      attr_writer :on_deregister

      def initialize(hostname = nil, port = nil)
        @hostname = hostname || lan_ip
        @port = port || 4200

        @nodes = {}

        @tcp_server = CisServer::Network::TcpServer.new @hostname, @port
        @tcp_server.on_connected = ->(node) { register node }
        @tcp_server.on_disconnected = ->(node) { deregister node }

        @udp_server = CisServer::Network::UdpServer.new @hostname, @port
        @udp_server.on_data_received = ->(ip, data) { udp_data_received ip, data }

        # NOTE: We need to keep this variable to prevent GC to trash it
        @dnssd_registrar = dnssd_register
        # TODO: registrar.stop
      end

      def run(task)
        @tcp_server.run(task)
        @udp_server.run(task)
      end

      private

      def register(node)
        node_description = "#{node} type: #{node.type} (#{node.remote_ip}:#{node.remote_port})"

        if @nodes[node.remote_ip].nil?
          Async.logger.debug "Node connected: #{node_description}"

          @on_register.call node
        else
          Async.logger.warn "Node reconnected: #{node_description}"
          # NOTE: This happends when node is hard-disconnected, previous
          # socket, so the node instance, is pending to close.
          # Then we just need to update node's associated instance (e.g. Car)

          @on_reregister.call node
        end
        @nodes[node.remote_ip] = node
      end

      def deregister(node)
        ip = node.remote_ip
        port = node.remote_port
        if @nodes[ip].remote_port == port
          Async.logger.debug "Node disconnected: #{node} (#{ip}:#{port})"

          node = @nodes[ip]
          @nodes[ip] = nil

          @on_deregister.call node
        else
          Async.logger.warn "Prevent from deregistering the node: #{node.remote_ip}, remote port mismatched"
          # NOTE: This happends when a previously hard-disconnected node have
          # been already reconnected but pending socket just closes
        end
      end

      def udp_data_received(ip, data)
        node = @nodes[ip]
        node&.udp_data_received(data)
      end

      def dnssd_register
        name = 'Car In Situ server'
        service = 'cisserver'
        proto = 'tcp'
        type = "_#{service}._#{proto}"

        # TODO: IP?
        registrar = DNSSD.register name, type, nil, @port unless ENV['CI']
        Async.logger.debug "DNSSD: service registered: #{registrar}"

        registrar
      end

      def lan_ip
        lan_ip_address = Socket.ip_address_list.find do |ip_address|
          ip_address.ipv4? && ip_address.ipv4_private?
        end
        lan_ip_address.ip_unpack.first
      end
    end
  end
end
