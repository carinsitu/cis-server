require 'socket'

module CarMaster
  class Car
    attr_reader :ip

    def initialize(ip)
      @ip = ip
      @udp_socket = UDPSocket.new
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
  end
end
