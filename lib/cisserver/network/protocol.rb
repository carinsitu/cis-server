require 'async/io/protocol/generic'

module CisServer
  module Network
    class Protocol < Async::IO::Protocol::Generic
      class CommandNotSupported < StandardError; end
      class Disconnected < StandardError; end

      PING = 0x00
      VERSION_GET = 0x01
      VIDEO_CHANNEL_SET = 0x05
      STEERING_SET = 0x10
      THROTTLE_SET = 0x11
      TRIM_STEERING_SET = 0x20
      RSSI = 0x80
      IRCODE = 0x81

      def read
        command = @stream.read(1)
        raise Disconnected if command.nil?

        command = command.unpack('C')[0]
        process_tcp_command command
      end

      def build_buffer(command, payload, packing)
        buffer = [command]
        buffer << payload unless payload.nil?
        buffer.pack "C#{packing}"
      end

      def send_tcp_command(command, payload = nil, packing = '')
        @stream.write build_buffer(command, payload, packing)
        @stream.flush
      end

      def type
        request_type_and_version if @type.nil?
        @type
      end

      def version
        request_type_and_version if @version.nil?
        @version
      end

      def request_type_and_version
        send_tcp_command(Protocol::VERSION_GET)
        Async do |task|
          task.sleep 0.1 while @version.nil?
        end
      end

      private

      def process_tcp_command(command) # rubocop:disable Metrics/MethodLength
        case command
        when PING
          Async.logger.debug 'Node reply to PING'
        when VERSION_GET
          data = @stream.read 4
          data = data.unpack 'CCCC'
          @type = data[0]
          @version = data[1..4].join '.'
          Async.logger.debug "Node type: #{@type}, version: #{@version}"
        else
          raise CommandNotSupported, command
        end
      end
    end
  end
end
