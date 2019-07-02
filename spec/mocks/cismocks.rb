module CisMocks
  class << self
    include RSpec::Mocks::ExampleMethods
    def setup
      mock_mqtt
    end

    def udp_instance
      @@udp_instance
    end

    private

    def mock_mqtt
      allow(MQTT::Client).to receive(:connect)
    end
  end
end
