require 'cisserver/car'

module CisServer
  class CarsMaster
    attr_reader :cars

    def initialize
      @cars_udp_socket = UDPSocket.new
      @cars_udp_socket.bind '0.0.0.0', 4200

      @cars = {}
    end

    def request_discovery_on_lan
      lan_ip_address = Socket.ip_address_list.find do |ip_address|
        ip_address.ipv4? && ip_address.ipv4_private?
      end
      lan_ip = lan_ip_address.ip_unpack.first
      lan_network = lan_ip.sub(/\.\d+$/, '')

      (1...254).each do |i|
        target_ip = "#{lan_network}.#{i}"
        data = [0x01].pack('c')
        @cars_udp_socket.send(data, 0, target_ip, 4210)
      end
    end

    def register(ip)
      return unless @cars[ip].nil?

      @cars[ip] = Car.new ip
      @register_closure.call @cars[ip]
    end

    def on_register(closure)
      @register_closure = closure
    end

    def handle_udp_socket
      response = @cars_udp_socket.recvfrom_nonblock 256
      if response[0][0] == "\x01"
        # discovery
        data = response[0].unpack 'ccccc'
        ip = response[1][3]
        puts "New car discovered: IP: #{ip}, version #{data[2]}.#{data[3]}.#{data[4]}"
        register ip
      else
        puts "Dropped: #{response}"
      end
    rescue IO::WaitReadable # rubocop:disable Lint/HandleExceptions
    end
  end
end
