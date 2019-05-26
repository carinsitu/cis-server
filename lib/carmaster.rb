require 'carmaster/version'

require 'carmaster/carsmaster'
require 'carmaster/gamecontrollersmaster'

require 'byebug'

require 'singleton'

module CarMaster
  class Error < StandardError; end

  class Master
    include Singleton

    def initialize
      @cars_master = CarsMaster.new
      @cars_master.request_discovery_on_lan

      @game_controllers_master = GameControllersMaster.new
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
