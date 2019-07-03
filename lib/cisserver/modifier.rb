module CisServer
  module Modifier
    class Base
      def throttle(value)
        value
      end

      def steering(value)
        value
      end
    end
    class Boost < Base
      def throttle(value)
        value * 2
      end
    end

    class Slow < Base
      def throttle(value)
        value * 0.15
      end
    end

    class InvertThrottle < Base
      def throttle(value)
        -value
      end
    end

    class InvertSteering < Base
      def steering(value)
        -value
      end
    end

    class InvertAll < Base
      def throttle(value)
        -value
      end

      def steering(value)
        -value
      end
    end

    LIST = (constants.reject { |c| %i[Base LIST].include? c }).freeze

    def self.random
      const_get(LIST.sample)
    end
  end
end
