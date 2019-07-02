require 'mocks/emulatedcar'

RSpec.describe CisServer::Network::TcpServer do
  include_context Async::RSpec::Reactor

  before(:all) do
    Async.logger.level = ::Logger::DEBUG
  end

  context 'when running', timeout: 5 do
    let(:subject) { CisServer::Network::TcpServer.new '127.0.0.1', 4200 }
    let(:car) { CisMocks::EmulatedCar.new }

    it 'accepts connections' do
      expect(subject).to receive :connected

      reactor_task = reactor.async do |task|
        subject.run(task)

        task.async do
          car.connect
          car.disconnect
        end
      end

      reactor_task.sleep 0.2
      reactor_task.stop
    end

    context 'when a node connects then disconnects' do
      it 'calls on_connected and on_disconnected closures' do
        subject.on_connected = ->(_node) { @on_connected_called = true }
        subject.on_disconnected = ->(_node) { @on_disconnected_called = true }

        reactor_task = reactor.async do |task|
          subject.run(task)

          task.async do
            car.connect
            car.disconnect
          end
        end

        reactor_task.sleep 0.2
        reactor_task.stop

        expect(@on_connected_called).to eq true
        expect(@on_disconnected_called).to eq true
      end
    end
  end
end
