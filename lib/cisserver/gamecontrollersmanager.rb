require 'cisserver/gamecontroller'

require 'sdl2'

module CisServer
  class GameControllersManager
    attr_reader :game_controllers

    attr_writer :on_register

    def initialize
      SDL2.init(SDL2::INIT_JOYSTICK)

      @game_controllers = {}

      @sdl_next_instance_id = 0
    end

    def register(sdl_device_id)
      game_controller = GameController.new(sdl_device_id)
      @game_controllers[@sdl_next_instance_id] = game_controller
      Async.logger.debug "Game controller registered: device_id=#{sdl_device_id} instance_id=#{@sdl_next_instance_id}"
      @sdl_next_instance_id += 1
      @on_register.call game_controller
    rescue GameController::DeviceNotSupported => e
      Async.logger.warn 'Unsupported device', e.message
      @sdl_next_instance_id += 1
    end

    def unregister(instance_id)
      Async.logger.debug "Game controller unregistered: instance_id=#{instance_id}"
      @game_controllers.delete_if { |id, _game_controller| instance_id == id }
    end

    def run(task)
      task.async do
        loop do
          process_sdl_events
          task.sleep 0.001
        end
      end
    end

    private

    def process_sdl_events
      return unless (event = SDL2::Event.poll)

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
