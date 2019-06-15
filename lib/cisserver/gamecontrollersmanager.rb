require 'cisserver/gamecontroller'

require 'sdl2'

module CisServer
  class GameControllersManager
    attr_reader :game_controllers

    def initialize
      SDL2.init(SDL2::INIT_JOYSTICK)

      @game_controllers = {}

      @sdl_next_instance_id = 0
    end

    def on_register(closure)
      @register_closure = closure
    end

    def register(sdl_device_id)
      game_controller = GameController.new(sdl_device_id)
      @game_controllers[@sdl_next_instance_id] = game_controller
      puts "Game controller registered: device_id=#{sdl_device_id} instance_id=#{@sdl_next_instance_id}"
      @sdl_next_instance_id += 1
      @register_closure.call game_controller
    rescue GameController::DeviceNotSupported
      puts 'Nope!'
    end

    def unregister(instance_id)
      puts "Game controller unregistered: instance_id=#{instance_id}"
      @game_controllers.delete_if { |id, _game_controller| instance_id == id }
    end

    def process_sdl_events
      while (event = SDL2::Event.poll)
        case event
        when SDL2::Event::JoyAxisMotion, SDL2::Event::JoyButton
          @game_controllers[event.which].process_event event
        when SDL2::Event::JoyDeviceAdded
          register event.which
        when SDL2::Event::JoyDeviceRemoved
          unregister event.which
        end
      end
    end
  end
end
