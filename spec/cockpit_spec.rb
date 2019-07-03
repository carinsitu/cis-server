RSpec.describe CisServer::Cockpit do
  context 'with no modifier' do
    let(:cockpit) { CisServer::Cockpit.new 0 }
    context 'when player throttles at 100 from the controller' do
      it 'returns  25' do
        expect(cockpit.send(:compute_car_throttle, 100)).to eq(25)
      end
    end
  end

  context 'with a boost modifier' do
    let(:cockpit) do
      cockpit = CisServer::Cockpit.new 0
      cockpit.send(:add_modifier, :Boost)
      cockpit
    end
    context 'when player throttles at 100' do
      it 'returns 50' do
        expect(cockpit.send(:compute_car_throttle, 100)).to eq(50)
      end
    end
  end

  context 'with 3 boost modifiers' do
    let(:cockpit) do
      cockpit = CisServer::Cockpit.new 0
      3.times { cockpit.send(:add_modifier, :Boost) }
      cockpit
    end
    context 'when player throttles at 32767' do
      it 'returns  32767' do
        expect(cockpit.send(:compute_car_throttle, 32_767)).to eq(32_767)
      end
    end
  end

  context 'with a steering inverter modifier' do
    let(:cockpit) do
      cockpit = CisServer::Cockpit.new 0
      cockpit.send(:add_modifier, :InvertSteering)
      cockpit
    end
    context 'when player steers at 100' do
      it 'returns -100' do
        expect(cockpit.send(:compute_car_steering, 100)).to eq(-100)
      end
    end
  end
end
