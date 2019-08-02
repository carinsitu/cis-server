module CisServer
  class GameController
    class DeviceNotSupported < StandardError; end

    attr_writer :on_throttle
    attr_writer :on_steering
    attr_writer :on_boost
    attr_writer :on_trim_steering

    def initialize(id)
      @id = id

      @on_throttle = ->(value) {}
      @on_steering = ->(value) {}
      @on_boost = ->(active) {}
      @on_trim_steering = ->(direction) {}

      @joystick = SDL2::Joystick.open(@id)

      raise DeviceNotSupported, @joystick.GUID unless @joystick.GUID == '030000006d0400001dc2000014400000'

      @last_forward_value = 0
      @last_backward_value = 0

      Async.logger.debug "GameController initialized: #{@joystick.name} (#{@joystick.GUID})"
    end

    def process_event(event)
      case event
      when SDL2::Event::JoyButton
        handle_button_event event
      when SDL2::Event::JoyAxisMotion
        handle_axis_event event
      end
    end

    private

    def handle_button_event(event)
      case event.button
      when 0
        @on_boost.call event.pressed
      when 4
        @on_trim_steering.call(-1) if event.pressed
      when 5
        @on_trim_steering.call(1) if event.pressed
      end
    end

    def handle_axis_event(event)
      case event.axis
      when 0
        @on_steering.call event.value
      when 2
        @on_throttle.call compute_throttle_from_backward_value(event.value)
      when 5
        @on_throttle.call compute_throttle_from_forward_value(event.value)
      end
    end

    def compute_throttle_from_forward_value(axis_value)
      # Compensate the trigger's "zero" which is at -32767
      @last_forward_value = (axis_value + 32_768) / 2
      @last_backward_value.zero? ? @last_forward_value : 0
    end

    def compute_throttle_from_backward_value(axis_value)
      # Compensate the trigger's "zero" which is at -32767
      @last_backward_value = -(axis_value + 32_768) / 2
      @last_forward_value.zero? ? @last_backward_value : 0
    end
  end
end
