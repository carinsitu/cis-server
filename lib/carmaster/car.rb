require 'socket'

module Carmaster
  class Car
    def initialize(ip, port, joystick)
      @ip = ip
      @port = port
      @joystick = SDL2::Joystick.open(joystick)
      @udp_socket = UDPSocket.new

      @joystick_last_forward = 0
      @joystick_last_backward = 0
    end

    def send(data)
      @udp_socket.send(data, 0, @ip, @port)
    end

    def process_joystick_event(event)
      case event.axis
      when 0
        self.steering = event.value
      when 2
        @joystick_last_backward = -(event.value + 32_768) / 2
        self.throttle = @joystick_last_forward.zero? ? @joystick_last_backward : 0
      when 5
        @joystick_last_forward = (event.value + 32_768) / 2
        self.throttle = @joystick_last_backward.zero? ? @joystick_last_forward : 0
      end
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
