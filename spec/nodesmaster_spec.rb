require 'mocks/emulatedcar'

RSpec.describe CisServer::Network::NodesMaster do
  include_context Async::RSpec::Reactor

  before(:all) do
    Async.logger.level = ::Logger::DEBUG
  end

  context 'when registering a new node', timeout: 10 do
    let(:subject) { CisServer::Network::NodesMaster.new '127.0.0.1', 4200 }
    let(:car) { CisMocks::EmulatedCar.new }

    it 'request the type and the version of node' do
      reactor_task = reactor.async do |task|
        subject.on_register = ->(node) { @node = node }
        subject.on_deregister = ->(node) {}

        task.async do |subtask|
          subject.run subtask
          car.connect
          reply_to_commands_task = car.reply_to_commands
          subtask.sleep 0.1
          reply_to_commands_task.stop
          car.disconnect
        end
      end

      reactor_task.sleep 1
      reactor_task.stop

      expect(@node).to_not be nil
      expect(@node.instance_variable_get(:@version)).to_not be nil
      expect(@node.instance_variable_get(:@type)).to_not be nil
    end
  end
end
