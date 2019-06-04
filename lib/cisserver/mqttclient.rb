require 'mqtt'
require 'singleton'

module CisServer
  class MqttClient
    include Singleton

    attr_reader :mqtt

    def initialize
      @mqtt = MQTT::Client.connect('localhost')
    end
  end
end
