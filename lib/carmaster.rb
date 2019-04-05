require "carmaster/version"
require 'socket'
require 'sdl2'

require 'byebug'

module Carmaster
  class Error < StandardError; end

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
      @udp_socket.send(data, 0, '192.168.1.35', @port)
      @udp_socket.send(data, 0, @ip, @port)
    end

    def process_joystick_event(ev)
      case ev.axis
      when 0
        self.steering= ev.value
      when 2
        @joystick_last_backward = -(ev.value + 32768)/2
        if @joystick_last_forward == 0
          self.throttle= @joystick_last_backward
        else
          self.throttle= 0
        end
      when 5
        @joystick_last_forward = (ev.value + 32768)/2
        if @joystick_last_backward == 0
          self.throttle= @joystick_last_forward
        else
          self.throttle= 0
        end
      end
    end

    def steering=(value)
      puts "#steering= #{value}"
      data = [ 0x10, value ].pack('cs')
      send data
    end

    def throttle=(value)
      puts "#throttle= #{value}"
      data = [ 0x11, value ].pack('cs')
      send data
    end
  end

  class Master
    def initialize
      SDL2.init(SDL2::INIT_EVERYTHING)

      window = SDL2::Window.create("testsprite",0, 0, 640, 480, 0)
      @renderer = window.create_renderer(-1, 0)

      (0...SDL2::Joystick.num_connected_joysticks).each do |i|
        create_car i
      end
    end

    def create_car(joystick)
      ip = '192.168.1.26'
      port = 4210
      puts "Create a Car instance connected to #{ip}:#{port} with joystick: #{joystick}"
      @car = Car.new ip, port, joystick
    end

    def run
      loop do
        while ev = SDL2::Event.poll
          case ev
          when SDL2::Event::JoyButton
            p ev
          when SDL2::Event::JoyAxisMotion
            p ev
            @car.process_joystick_event ev
          when SDL2::Event::JoyDeviceAdded
            p ev
            #create_car(ev.which)
          when SDL2::Event::JoyDeviceRemoved
            p ev
          when SDL2::Event::KeyDown
            if ev.scancode == SDL2::Key::Scan::ESCAPE
              exit
            end
          when SDL2::Event::Quit
            exit
          end
        end

        @renderer.present
        sleep 0.1
      end
    end
  end
end
