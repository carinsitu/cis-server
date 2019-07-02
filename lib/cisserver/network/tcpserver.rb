require 'cisserver/network/node'

require 'async/io/host_endpoint'

module CisServer
  module Network
    class TcpServer
      attr_writer :on_connected
      attr_writer :on_disconnected

      def initialize(hostname, port)
        @endpoint = Async::IO::Endpoint.parse("tcp://#{hostname}:#{port}")
      end

      def connected(node)
        Async.logger.debug "#{node} New node"

        @on_connected.call node

        node.run
      rescue Errno::ECONNRESET, IOError => e
        Async.logger.debug "#{node} Handled exception occured: #{e}"
      ensure
        disconnected(node)
      end

      def disconnected(node, reason = 'quit')
        Async.logger.info "#{node} has disconnected: #{reason}"
        @on_disconnected.call node
      end

      def run(task)
        Async.logger.debug "TCP server accepts connections on #{@endpoint}"
        task.async do
          @endpoint.accept do |peer|
            stream = Async::IO::Stream.new(peer)
            node = Node.new(stream)
            connected(node)
          end
        end
      end
    end
  end
end
