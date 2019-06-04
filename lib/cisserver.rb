require 'cisserver/version'

require 'cisserver/carsmaster'
require 'cisserver/cockpitsmanager'
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

      @cockpit_manager = CockpitsManager.new @cars_master, @game_controllers_master
    end

    def run
      loop do
        @cars_master.handle_udp_socket
        @game_controllers_master.process_sdl_events

        sleep 0.001
      end
    end
  end
end
