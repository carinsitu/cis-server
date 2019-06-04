require 'socket'

module CisServer
  class Car
    attr_reader :ip

    def initialize(ip)
      @ip = ip
      @udp_socket = UDPSocket.new
      @trim_steering = 0

      @throttle_factor = 0.25
      @throttle_raw = 0

      puts "Car(#{@ip}) instanciated"
    end

    def send_data(data)
      @udp_socket.send(data, 0, @ip, 4210)
    end

    def steering=(value)
      puts "#steering= #{value}"
      data = [0x10, value].pack('cs')
      send_data data
    end

    def throttle=(value)
      @throttle_raw = value
      value *= @throttle_factor
      puts "#throttle= #{value}"
      data = [0x11, value].pack('cs')
      send_data data
    end

    def trim_steering(value)
      puts "#trim_steering= #{@trim_steering}"
      @trim_steering += value
      data = [0x20, @trim_steering].pack('cc')
      send_data data
      self.steering = 0
    end

    def throttle_factor=(value)
      @throttle_factor = value
      self.throttle = @throttle_raw
    end
  end
end
