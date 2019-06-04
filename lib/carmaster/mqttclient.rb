require 'mqtt'
require 'singleton'

module CarMaster
  class MqttClient
    include Singleton

    attr_reader :mqtt

    def connect
      @mqtt = MQTT::Client.connect('localhost')
    end
  end
end
