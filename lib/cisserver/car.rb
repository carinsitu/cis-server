require 'socket'

require 'cisserver/network/node'
require 'cisserver/videochannel'

module CisServer
  class Car
    attr_reader :ip
    attr_reader :rssi

    attr_writer :on_rssi
    attr_writer :on_ir

    attr_reader :node

    def initialize(node)
      @ip = node.remote_ip
      self.node = node

      @trim_steering = 0

      @on_rssi = ->(rssi) {}
      @on_ir = ->(ir) {}

      Async.logger.debug 'New Car'
    end

    def steering=(value)
      @node.send_udp_command(CisServer::Network::Protocol::STEERING_SET, value, 's')
    end

    def throttle=(value)
      @node.send_udp_command(CisServer::Network::Protocol::THROTTLE_SET, value, 's')
    end

    def trim_steering=(value)
      Async.logger.debug "#trim_steering= #{@trim_steering}"
      @trim_steering += value
      @node.send_tcp_command(CisServer::Network::Protocol::TRIM_STEERING_SET, value, 'c')
      self.steering = 0
    end

    def video_channel=(value)
      Async.logger.debug "#video_channel= #{value} (#{CisServer::VideoChannel.describe value})"
      @node.send_tcp_command(CisServer::Network::Protocol::VIDEO_CHANNEL_SET, value, 'C')
    end

    def node=(node)
      @node = node
      @node.on_udp_data = ->(data) { handle_incomming_data data }
    end

    def handle_incomming_data(data)
      command = data.unpack('C*')[0]
      case command
      when CisServer::Network::Protocol::RSSI
        self.rssi = data.unpack('Cl')[1]
      when CisServer::Network::Protocol::IRCODE
        @on_ir.call data.unpack('CQ')[1]
      else
        Async.logger.warn "Dropped message #{data.unpack('H*')}"
      end
    end

    def rssi=(value)
      return unless @rssi != value

      @on_rssi.call value
      @rssi = value
    end
  end
end
