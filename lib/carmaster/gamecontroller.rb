module CarMaster
  class GameController
    def initialize(id)
      @id = id

      @joystick = SDL2::Joystick.open(@id)

      @last_forward_value = 0
      @last_backward_value = 0
    end

    def car=(car)
      @car = car
      puts "Joystick(#{@id}) is now associated with car(#{@car.ip})"
    end

    def process_event(event)
      return if @car.nil?

      case event.axis
      when 0
        @car.steering = event.value
      when 2
        @car.throttle = compute_throttle_from_backward_value(event.value)
      when 5
        @car.throttle = compute_throttle_from_forward_value(event.value)
      end
    end

    private

    def compute_throttle_from_forward_value(axis_value)
      @last_forward_value = (axis_value + 32_768) / 2
      @last_backward_value.zero? ? @last_forward_value : 0
    end

    def compute_throttle_from_backward_value(axis_value)
      @last_backward_value = -(axis_value + 32_768) / 2
      @last_forward_value.zero? ? @last_backward_value : 0
    end
  end
end
