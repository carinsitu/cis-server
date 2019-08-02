module SDL2
  INIT_JOYSTICK = :joystick

  def self.init(_)
    Event::Fake.init
  end

  module Event
    def self.poll
      Fake.shift
    end

    class JoyAxisMotion
      attr_reader :which
      attr_reader :axis
      attr_reader :value

      def initialize(which, axis, value)
        @which = which
        @axis = axis
        @value = value
      end
    end

    class JoyButton
    end

    class JoyDeviceAdded
      attr_reader :which
      def initialize(which)
        @which = which
      end
    end

    class JoyDeviceRemoved
    end

    module Fake
      def self.init
        @@events = []
      end

      def self.push(event)
        @@events.push event
      end

      def self.shift
        @@events.shift
      end
    end
  end

  class Joystick
    def self.open(id)
      SDL2::Joystick::Fake.joysticks[id]
    end

    module Fake
      def self.plug(joystick)
        id = joysticks.count
        joysticks << joystick
        SDL2::Event::Fake.push SDL2::Event::JoyDeviceAdded.new(id)
        id
      end

      def self.joysticks
        @@joysticks ||= []
      end

      def self.teardown
        @@joysticks = []
      end
    end
  end
end
