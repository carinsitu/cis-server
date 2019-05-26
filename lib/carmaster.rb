require 'carmaster/version'

require 'carmaster/carsmaster'
require 'carmaster/gamecontroller'

require 'sdl2'

require 'byebug'

module CarMaster
  class Error < StandardError; end

  class Master
    def initialize
      SDL2.init(SDL2::INIT_JOYSTICK)

      @game_controllers = {}

      @cars_master = CarsMaster.new
      @cars_master.request_discovery_on_lan
    end

    def run # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
      loop do
        @cars_master.handle_udp_socket

        while (event = SDL2::Event.poll)
          case event
          when SDL2::Event::JoyAxisMotion, SDL2::Event::JoyButton
            p event
            @game_controllers[event.which].process_event event
          when SDL2::Event::JoyDeviceAdded
            p event
            game_controller = GameController.new(event.which)
            @game_controllers[event.which] = game_controller
            game_controller.car = @cars_master.cars.first.last
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
