module CisMocks
  class EmulatedGameController
    def initialize(master)
      @gamepad = EmulatedGamepad.new master
    end

    def move_forward(value)
      @gamepad.move(5, (32_767 * 2 * value) - 32_768)
    end
  end
end
