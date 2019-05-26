require 'socket'

module CarMaster
  class Car
    attr_reader :ip

    def initialize(ip)
      @ip = ip
      @udp_socket = UDPSocket.new
      @trim_steering = 0
      puts "Car(#{@ip}) instanciated"
    end

    def send(data)
      @udp_socket.send(data, 0, @ip, 4210)
    end

    def steering=(value)
      puts "#steering= #{value}"
      data = [0x10, value].pack('cs')
      send data
    end

    def throttle=(value)
      puts "#throttle= #{value}"
      data = [0x11, value].pack('cs')
      send data
    end

    def trim_steering(value)
      puts "#trim_steering= #{@trim_steering}"
      @trim_steering += value
      data = [0x20, @trim_steering].pack('cc')
      send data
      self.steering = 0
    end
  end
end
