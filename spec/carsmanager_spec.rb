require 'ostruct'

require 'cisserver/carsmanager'
require 'mocks/emulatedcar'

RSpec.describe CisServer::CarsManager do
  let(:subject) do
    carsmanager = CisServer::CarsManager.new
    carsmanager.on_register = ->(_node) {}
    carsmanager.on_deregister = ->(_node) {}
    carsmanager
  end

  let(:carnode) do
    carnode = OpenStruct.new
    carnode.remote_ip = '123.45.67.89'
    carnode
  end

  context 'when registering a new node' do
    it 'creates a new Car instance' do
      expect(CisServer::Car).to receive(:new)
      subject.register carnode
    end

    it 'keep the created Car per IP' do
      subject.register carnode
      expect(subject.instance_variable_get(:@cars).count).to eq 1
      expect(subject.instance_variable_get(:@cars)[carnode.remote_ip]).to_not be nil
    end

    it 'calls on_register callback' do
      subject.on_register = ->(_node) { @called = true }
      subject.register carnode
      expect(@called).to be true
    end
  end

  context 'when reregistering a new node' do
    before(:each) do
      subject.register carnode
    end

    it 'does not create a new Car' do
      expect(CisServer::Car).to_not receive(:new)
      subject.reregister carnode
    end
  end

  context 'when deregistering an existing node' do
    before(:each) do
      subject.register carnode
    end

    it 'removes associated Car from cars hash' do
      expect(subject.instance_variable_get(:@cars).count).to eq 1
      subject.deregister carnode
      expect(subject.instance_variable_get(:@cars).count).to eq 0
    end

    it 'calls on_deregistering' do
      subject.on_deregister = ->(_node) { @called = true }
      subject.deregister carnode
      expect(@called).to be true
    end
  end
end
