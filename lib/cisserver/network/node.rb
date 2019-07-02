require 'cisserver/network/protocol'

module CisServer
  module Network
    class Node < Protocol
      attr_reader :remote_ip
      attr_reader :remote_port

      attr_writer :on_udp_data

      def initialize(stream)
        super(stream)

        @remote_ip = @stream.io.io.remote_address.ip_address
        @remote_port = @stream.io.io.remote_address.ip_port

        Async.logger.debug "New node accepted: #{remote_ip}:#{remote_port}"

        @connected = true
      end

      def send_udp_data(data)
        @udp_socket.send(data, 0, remote_ip, 4210)
      end

      def send_udp_command(command, data = nil, packing = '')
        send_udp_data build_buffer(command, data, packing)
      end

      def udp_data_received(data)
        @on_udp_data.call data
      end

      def connected?
        @connected
      end

      def run
        @udp_socket = UDPSocket.new

        until @stream.closed?
          begin
            read
          rescue Disconnected
            @stream.close
          end
        end
      ensure
        @udp_socket.close
      end
    end
  end
end
