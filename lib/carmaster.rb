require 'carmaster/version'
require 'carmaster/car'

require 'sdl2'

require 'byebug'

module CarMaster
  class Error < StandardError; end

  class Master
    def initialize
      SDL2.init(SDL2::INIT_JOYSTICK)

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
            create_car(event.which)
          when SDL2::Event::JoyDeviceRemoved
            p event
          when SDL2::Event::KeyDown
            exit if event.scancode == SDL2::Key::Scan::ESCAPE
          when SDL2::Event::Quit
            exit
          end
        end

        sleep 0.001
      end
    end
  end
end
