require 'cisserver'

module CisServer
  class Cockpit
    attr_reader :controller
    attr_reader :car

    VIDEO_CHANNEL_FOR_ID = {
      # TODO: Find the right channels for each cockpit and hardcode them here
      0 => 9,
      1 => 19,
      2 => 29,
      3 => 39,
    }.freeze

    def initialize(id)
      @id = id
    end

    def car=(car)
      @car = car

      @car.video_channel = VIDEO_CHANNEL_FOR_ID[@id]

      pair_devices unless @controller.nil?
    end

    def controller=(controller)
      @controller = controller
      pair_devices unless @car.nil?
    end

    def pair_devices
      setup_controller
      setup_car
    end

    private

    def setup_controller
      @controller.on_throttle = lambda { |throttle|
        @car.throttle = throttle
        Master.announce "cockpit/#{@id}/car/throttle", throttle.to_s
      }
      @controller.on_steering = ->(steering) { @car.steering = steering }
      @controller.on_boost = ->(boost) { @car.throttle_factor = boost ? 1.0 : 0.25 }
      @controller.on_trim_steering = ->(direction) { @car.trim_steering = direction }
    end

    def setup_car
      @car.on_rssi = lambda { |rssi|
        Master.announce "cockpit/#{@id}/car/rssi", rssi unless @car.rssi == rssi
      }
      @car.on_ir = lambda { |code|
        puts "Cockpit #{@id}: IR: #{code}"
      }
    end
  end
end
