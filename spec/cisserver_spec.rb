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
    CisMocks.stub_mqtt
  end

  let(:master) { CisServer::Master.new '127.0.0.1' }

  it 'can be instantiated' do
    expect(master).to be_instance_of CisServer::Master
  end
end
