require 'cisserver/cockpit'

module CisServer
  class CockpitsManager
    def initialize(cars_manager, game_controllers_manager)
      @cars_manager = cars_manager
      @game_controllers_manager = game_controllers_manager
      @game_controllers_manager.on_register = ->(device) { auto_pair device }

      @cars_manager.on_register = ->(device) { auto_pair device }
      @cars_manager.on_deregister = ->(device) { deregister device }

      @cockpits = []
      4.times do |i|
        @cockpits.push(Cockpit.new(i))
      end
    end

    def auto_pair(device)
      case device
      when Car
        cockpit = @cockpits.find { |c| c.car.nil? }
        cockpit.car = device unless cockpit.nil?
      when GameController
        cockpit = @cockpits.find { |c| c.controller.nil? }
        cockpit.controller = device unless cockpit.nil?
      else
        raise "Unknown device: #{device}"
      end
    end

    private

    def find_available_game_controller
      game_controller = @game_controllers_manager.game_controllers.find { |_key, value| value.car.nil? }

      return nil if game_controller.nil?

      game_controller[1]
    end

    def find_available_car
      cars = @cars_manager.cars.map { |_key, value| value }
      paired_cars = @game_controllers_manager.game_controllers.map { |_key, value| value.car }
      unpaired_cars = cars - paired_cars

      return nil if unpaired_cars.empty?

      unpaired_cars.first
    end

    def deregister
      # TODO: Implement me
      raise 'Not implemented'
    end
  end
end
