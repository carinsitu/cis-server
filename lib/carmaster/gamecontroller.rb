module CarMaster
  class GameController
    attr_reader :car

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

      case event
      when SDL2::Event::JoyButton
        case event.button
        when 0
          @car.throttle_factor = event.pressed ? 1.0 : 0.25
        when 4
          @car.trim_steering(-1)
        when 5
          @car.trim_steering(1)
        end
      when SDL2::Event::JoyAxisMotion
        case event.axis
        when 0
          @car.steering = event.value
        when 2
          @car.throttle = compute_throttle_from_backward_value(event.value)
        when 5
          @car.throttle = compute_throttle_from_forward_value(event.value)
        end
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
