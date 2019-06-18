module CisMocks
  class << self
    include RSpec::Mocks::ExampleMethods
    def setup
      mock_mqtt
      mock_udp
    end

    def udp_class
      @@udp_class
    end

    def udp_instance
      @@udp_instance
    end

    private

    def mock_mqtt
      allow(MQTT::Client).to receive(:connect)
    end

    def mock_udp
      @@udp_class = class_double(UDPSocket).as_stubbed_const # rubocop:disable Style/ClassVars
      @@udp_instance = instance_double(UDPSocket) # rubocop:disable Style/ClassVars
      allow(@@udp_class).to receive(:new) { @@udp_instance }
      allow(@@udp_instance).to receive(:bind).with('0.0.0.0', 4200)
      allow(@@udp_instance).to receive(:send)
    end
  end
end
