module CisMocks
  class EmulatedCar
    def initialize
      @endpoint = Async::IO::Endpoint.parse('tcp://127.0.0.1:4200')
    end

    def connect
      Async.logger.debug "#{self}: Connecting..."
      @socket = @endpoint.connect
      Async.logger.debug "#{self}: Connected"
    end

    def reply_to_commands
      Async do
        loop do
          case read_command
          when CisServer::Network::Protocol::VERSION_GET
            @socket.write([CisServer::Network::Protocol::VERSION_GET, 0x00, 0xff, 0xaa, 0x00].pack('C*'))
          else
            raise "Command not supported: #{command}, #{CisServer::Network::Protocol::VERSION_GET}"
          end
        end
      end
    end

    def disconnect
      @socket&.close
    end

    private

    def read_command
      command = @socket.read(1)
      command.unpack('C')[0]
    end
  end
end
