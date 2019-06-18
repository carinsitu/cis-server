module CisMocks
  class EmulatedCar
    include RSpec::Mocks::ExampleMethods
    def initialize(master)
      @master = master

      allow(CisMocks.udp_instance).to receive(:recvfrom_nonblock) do
        [[0x01, 0x01, 0x00, 0x00, 0x00].pack('CCCCC'), [nil, nil, nil, '127.0.0.1']]
      end

      # Processing inputs should detect a new car
      @master.process_inputs

      allow(CisMocks.udp_instance).to receive(:recvfrom_nonblock).and_raise(StandardError.new.extend(IO::WaitReadable))
    end
  end
end
