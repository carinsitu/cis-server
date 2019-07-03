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

  it 'can be instantiated' do
    expect(master).to be_instance_of CisServer::Master
  end
end
