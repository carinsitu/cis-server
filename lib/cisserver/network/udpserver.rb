require 'async'
require 'async/io'

module CisServer
  module Network
    class UdpServer
      attr_writer :on_data_received

      def initialize(hostname, port)
        @endpoint = Async::IO::Endpoint.udp(hostname, port)
      end

      def run(task)
        task.async do
          @endpoint.bind do |socket|
            loop do
              data, address = socket.recvfrom(1024)
              @on_data_received.call address.ip_address, data
            end
          end
        end
      end
    end
  end
end
