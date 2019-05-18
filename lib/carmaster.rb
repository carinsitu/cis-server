require 'carmaster/version'
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

  class Master
    def initialize
      SDL2.init(SDL2::INIT_EVERYTHING)

      window = SDL2::Window.create('testsprite', 0, 0, 640, 480, 0)
      @renderer = window.create_renderer(-1, 0)

      (0...SDL2::Joystick.num_connected_joysticks).each do |i|
        create_car i
      end
    end

    def create_car(joystick)
      ip = '192.168.37.169'
      port = 4210
      puts "Create a Car instance connected to #{ip}:#{port} with joystick: #{joystick}"
      @car = Car.new ip, port, joystick
    end

    def run # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
      loop do
        while (event = SDL2::Event.poll)
          case event
          when SDL2::Event::JoyButton
            p event
          when SDL2::Event::JoyAxisMotion
            p event
            @car.process_joystick_event event
          when SDL2::Event::JoyDeviceAdded
            p event
            # create_car(event.which)
          when SDL2::Event::JoyDeviceRemoved
            p event
          when SDL2::Event::KeyDown
            exit if event.scancode == SDL2::Key::Scan::ESCAPE
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
