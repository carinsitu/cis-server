require 'cisserver'
require 'cisserver/modifier'

module CisServer
  class Cockpit
    attr_reader :controller
    attr_reader :car

    VIDEO_CHANNEL_FOR_ID = {
      0 => 32, # Raceband, Channel 1
      1 => 33, # Raceband, Channel 2
      2 => 24, # Fatshark, Channel 1
      3 => 26, # Fatshark, Channel 3
    }.freeze

    def initialize(id)
      @id = id
      @modifiers = []
      @throttle_factor = 0.25
    end

    def car=(car)
      @car = car
      return if car.nil?

      @car.video_channel = VIDEO_CHANNEL_FOR_ID[@id]

      pair_devices unless @controller.nil?
    end

    def controller=(controller)
      @controller = controller
      pair_devices unless @car.nil? || controller.nil?
    end

    def pair_devices
      setup_controller
      setup_car
    end

    private

    def setup_controller
      @controller.on_throttle = lambda { |throttle|
        value = compute_car_throttle throttle
        @car.throttle = value
        Master.announce "cockpit/#{@id}/car/throttle", value.to_int.to_s
      }
      @controller.on_steering = ->(steering) { @car.steering = compute_car_steering steering }
      @controller.on_boost = ->(boost) { @throttle_factor = boost ? 1.0 : 0.25 }
      @controller.on_trim_steering = ->(direction) { @car.trim_steering = direction }
      @controller.on_save_settings = ->() { @car.persist_remote_settings }
    end

    def setup_car
      @car.on_rssi = lambda { |rssi|
        Master.announce "cockpit/#{@id}/car/rssi", rssi unless @car.rssi == rssi
      }
      @car.on_ir = lambda { |code|
        Async.logger.debug "IRCODE: #{code}"
      }
    end

    def compute_car_throttle(controller_value)
      value = controller_value * @throttle_factor
      compute_car_property(:throttle, value)
    end

    def compute_car_steering(controller_value)
      compute_car_property(:steering, controller_value)
    end

    def compute_car_property(property, controller_value, min = -32_768, max = 32_767)
      value = @modifiers.reduce(controller_value) do |memo, modifier|
        modifier.send(property, memo)
      end

      return min if value < min
      return max if value > max

      value
    end

    def add_modifier(bonus)
      modifier = CisServer::Modifier.const_get bonus
      @modifiers.push(modifier.new)
    end
  end
end
