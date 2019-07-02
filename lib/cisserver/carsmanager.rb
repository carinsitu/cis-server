require 'cisserver/car'

module CisServer
  class CarsManager
    attr_reader :cars

    attr_writer :on_register
    attr_writer :on_deregister

    def initialize
      @cars = {}
    end

    def register(node)
      Async.logger.info "Registering a new car connected from #{node.remote_ip}:#{node.remote_port}"
      car = Car.new node
      @cars[node.remote_ip] = car
      @on_register.call car
    end

    def reregister(node)
      Async.logger.info "Updating the car's node with IP: #{node.remote_ip}:#{node.remote_port}"
      @cars[node.remote_ip].node = node
    end

    def deregister(node)
      Async.logger.info "Deregistering the car with IP: #{node.remote_ip}"
      car = @cars[node.remote_ip]
      @cars.delete_if { |k, _v| k == node.remote_ip }
      @on_deregister.call car
    end
  end
end
