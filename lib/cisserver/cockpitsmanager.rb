require 'cisserver/cockpit'

module CisServer
  class CockpitsManager
    def initialize(cars_master, game_controllers_master)
      @cars_master = cars_master
      @game_controllers_master = game_controllers_master
      @game_controllers_master.on_register ->(device) { auto_pair device }
      @cars_master.on_register ->(device) { auto_pair device }

      @cockpits = []
      4.times { @cockpits.push(Cockpit.new) }
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
