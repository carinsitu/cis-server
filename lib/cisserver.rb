require 'cisserver/version'

require 'cisserver/carsmaster'
require 'cisserver/gamecontrollersmaster'

require 'byebug'

require 'singleton'

module CisServer
  class Error < StandardError; end

  class Master
    include Singleton

    def initialize
      @cars_master = CarsMaster.new
      @cars_master.request_discovery_on_lan

      @game_controllers_master = GameControllersMaster.new
    end

    def run
      loop do
        @cars_master.handle_udp_socket
        @game_controllers_master.process_sdl_events

        sleep 0.001
      end
    end

    def auto_pair(device)
      case device
      when Car
        game_controller = find_available_game_controller
        game_controller.car = device unless game_controller.nil?
      when GameController
        car = find_available_car
        device.car = car unless car.nil?
      else
        raise "Unknown device: #{device}"
      end
    end

    private

    def find_available_game_controller
      game_controller = @game_controllers_master.game_controllers.find { |_key, value| value.car.nil? }

      return nil if game_controller.nil?

      game_controller[1]
    end

    def find_available_car
      cars = @cars_master.cars.map { |_key, value| value }
      paired_cars = @game_controllers_master.game_controllers.map { |_key, value| value.car }
      unpaired_cars = cars - paired_cars

      return nil if unpaired_cars.empty?

      unpaired_cars.first
    end
  end
end
