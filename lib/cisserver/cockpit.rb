require 'cisserver/mqttclient'

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
      @controller.on_throttle lambda { |throttle|
        @car.throttle = throttle
        MqttClient.instance.mqtt.publish "carinsitu/cockpit/#{@id}/car/throttle", throttle.to_s
      }
      @controller.on_steering ->(steering) { @car.steering = steering }
      @controller.on_boost ->(boost) { @car.throttle_factor = boost ? 1.0 : 0.25 }
    end
  end
end
