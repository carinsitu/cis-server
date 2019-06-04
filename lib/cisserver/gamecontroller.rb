module CisServer
  class GameController
    class DeviceNotSupported < StandardError; end

    def initialize(id)
      @closures = {
        throttle: -> {},
        steering: -> {},
        boost: -> {},
      }
      @id = id

      @joystick = SDL2::Joystick.open(@id)
      raise DeviceNotSupported unless @joystick.GUID == '030000006d0400001dc2000014400000'

      @last_forward_value = 0
      @last_backward_value = 0

      puts "Initialized #{@joystick.name} (#{@joystick.GUID})"
    end

    def car=(car)
      @car = car
      puts "Joystick(#{@id}) is now associated with car(#{@car.ip})"
    end

    def process_event(event)
      case event
      when SDL2::Event::JoyButton
        handle_button_event event
      when SDL2::Event::JoyAxisMotion
        handle_axis_event event
      end
    end

    def on_throttle(closure)
      @closures[:throttle] = closure
    end

    def on_steering(closure)
      @closures[:steering] = closure
    end

    def on_boost(closure)
      @closures[:boost] = closure
    end

    private

    def handle_button_event(event)
      case event.button
      when 0
        @closures[:boost].call event.pressed
      when 4
        @car.trim_steering(-1)
      when 5
        @car.trim_steering(1)
      end
    end

    def handle_axis_event(event)
      case event.axis
      when 0
        @closures[:steering].call event.value
      when 2
        @closures[:throttle].call compute_throttle_from_backward_value(event.value)
      when 5
        @closures[:throttle].call compute_throttle_from_forward_value(event.value)
      end
    end

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
