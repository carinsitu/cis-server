require 'ostruct'

require 'mocks/cismocks'
require 'mocks/emulatedcar'
require 'mocks/emulatedgamepad'

RSpec.describe CisServer do
  it 'has a version number' do
    expect(CisServer::VERSION).not_to be nil
  end
end

RSpec.describe CisServer::Master do
  before(:each) do
    # Prepare CisServer to work with emulated devices (ie. mock classes)
    CisMocks.setup
  end

  let(:master) { CisServer::Master.new }

  it 'can be instanciated' do
    expect(master).to be_instance_of CisServer::Master
  end

  context 'gamepad´s right trigger pressed' do
    let(:gamepad) { CisMocks::EmulatedGamepad.new master }
    let(:car) { CisMocks::EmulatedCar.new master }

    before do
      # Instanciate emulated car
      car
      # Instanciate emulated gamepad
      gamepad
    end

    it 'send throttle through MQTT' do
      expect(master.class).to receive(:announce).with('cockpit/0/car/throttle', '32767')
      # Move right trigger (ie. axis 5) to value: 24042
      gamepad.move 5, 32_767
    end
  end
end
