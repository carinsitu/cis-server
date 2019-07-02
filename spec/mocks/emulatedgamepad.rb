module CisMocks
  class EmulatedGamepad
    include RSpec::Mocks::ExampleMethods

    def initialize(master)
      @master = master

      @event_class = class_double('SDL2::Event').as_stubbed_const(transfer_nested_constants: true)
      allow(@event_class).to receive(:poll) { SDL2::Event::JoyDeviceAdded.new }

      joystick_class = class_double('SDL2::Joystick').as_stubbed_const(transfer_nested_constants: true)
      allow(joystick_class).to receive(:open) do
        joystick = OpenStruct.new
        joystick.GUID = '030000006d0400001dc2000014400000' # Logitech GamePad
        joystick
      end

      process
    end

    def move(axis, value)
      allow(@event_class).to receive(:poll) do
        axis_event = SDL2::Event::JoyAxisMotion.new
        axis_event.axis = axis
        axis_event.value = value
        axis_event
      end

      process
    end

    private

    def process
      @gm = @master.instance_variable_get :@game_controllers_manager
      @gm.send :process_sdl_events
    end
  end
end
