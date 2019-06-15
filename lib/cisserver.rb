require 'cisserver/version'

require 'cisserver/carsmanager'
require 'cisserver/cockpitsmanager'
require 'cisserver/gamecontrollersmanager'

require 'byebug'

require 'singleton'

module CisServer
  class Error < StandardError; end

  class Master
    include Singleton

    def initialize
      @cars_manager = CarsManager.new
      @cars_manager.request_discovery_on_lan

      @game_controllers_manager = GameControllersManager.new

      @cockpit_manager = CockpitsManager.new @cars_manager, @game_controllers_manager
    end

    def run
      loop do
        @cars_manager.handle_udp_socket
        @game_controllers_manager.process_sdl_events

        sleep 0.001
      end
    end
  end
end
