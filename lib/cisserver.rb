require 'cisserver/version'

require 'cisserver/carsmanager'
require 'cisserver/cockpitsmanager'
require 'cisserver/gamecontrollersmanager'
require 'cisserver/network/nodesmaster'

require 'byebug'

require 'mqtt'
require 'async'

module CisServer
  class Error < StandardError; end

  class Master
    def initialize(hostname = nil, port = nil)
      Async.logger.level = ::Logger::DEBUG
      Async.logger.info('Starting Car In Situ server...')

      @@mqtt ||= MQTT::Client.connect('localhost') # rubocop:disable Style/ClassVars
      @cars_manager = CarsManager.new
      @game_controllers_manager = GameControllersManager.new
      @cockpit_manager = CockpitsManager.new @cars_manager, @game_controllers_manager

      setup_nodes_master hostname, port
    end

    def run(task)
      @nodes_master.run(task)
      @game_controllers_manager.run(task)
    end

    def self.announce(topic, message)
      @@mqtt.publish "carinsitu/#{topic}", message
    end

    private

    def setup_nodes_master(hostname, port)
      @nodes_master = CisServer::Network::NodesMaster.new hostname, port

      # TODO: Break this to support more then Car node type
      @nodes_master.on_register = ->(node) { @cars_manager.register node }
      @nodes_master.on_reregister = ->(node) { @cars_manager.reregister node }
      @nodes_master.on_deregister = ->(node) { @cars_manager.deregister node }
    end
  end
end
