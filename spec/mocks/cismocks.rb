module CisMocks
  class << self
    include RSpec::Mocks::ExampleMethods

    def stub_sdl2
      lib = File.expand_path('.', __dir__)
      $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
    end

    def stub_mqtt
      mqtt = class_double('MQTT::Client').as_stubbed_const
      allow(mqtt).to receive :connect
    end

    def announces
      @@anounces ||= []
    end

    def teardown
      @@announces = []
      SDL2::Joystick::Fake.teardown
    end
  end
end
