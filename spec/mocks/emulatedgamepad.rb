module CisMocks
  class EmulatedGamepad
    def initialize
      @id = SDL2::Joystick::Fake.plug(self)
    end

    def GUID # rubocop:disable Naming/MethodName
      '030000006d0400001dc2000014400000'
    end

    def name
      'Emulated Logitech GamePad F310'
    end

    def move(axis, value)
      SDL2::Event::Fake.push SDL2::Event::JoyAxisMotion.new(@id, axis, value)
    end
  end
end
