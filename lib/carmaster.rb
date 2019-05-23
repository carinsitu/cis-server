require 'carmaster/version'
require 'carmaster/car'
require 'carmaster/gamecontroller'

require 'sdl2'

require 'byebug'

module CarMaster
  class Error < StandardError; end

  class Master
    def initialize
      SDL2.init(SDL2::INIT_JOYSTICK)

      @game_controllers = {}

      @cars = [
        Car.new('192.168.1.26'), # Got
        Car.new('192.168.1.46'), # Manu
        Car.new('192.168.1.44'), # Romu
      ]
    end

    def run # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
      loop do
        while (event = SDL2::Event.poll)
          case event
          when SDL2::Event::JoyAxisMotion, SDL2::Event::JoyButton
            p event
            @game_controllers[event.which].process_event event
          when SDL2::Event::JoyDeviceAdded
            p event
            game_controller = GameController.new(event.which)
            @game_controllers[event.which] = game_controller
            game_controller.car = @cars.pop
          when SDL2::Event::JoyDeviceRemoved
            p event
            @game_controllers[event.which] = nil
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
