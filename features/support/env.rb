require 'rspec'
require 'cucumber/rspec/doubles'

require_relative '../../spec/doubles/cisdoubles'
CisDoubles.stub_sdl2

require 'cisserver'
require_relative '../../spec/doubles/cisdoubles/cisserver'

require_relative '../../spec/doubles/emulatedcar'
require_relative '../../spec/doubles/emulatedgamepad'
require_relative '../../spec/doubles/emulatedgamecontroller'

Async.logger.level = ::Logger::DEBUG

Before do
  CisDoubles.stub_mqtt
end

Around do |scenario, block|
  Async.logger.debug " === CUCUMBER: Starting scenario: #{scenario.name}"

  result = false
  @reactor = Async do |task|
    task.async do
      result = block.call
    end
    Async.logger.debug ' === CUCUMBER: Scenario mother task sleeping...'
    task.sleep 1
    Async.logger.debug ' === CUCUMBER: Stop scenario mother task'
    task.stop
  end

  @reactor.wait

  Async.logger.debug ' === CUCUMBER: Reactor done'

  CisDoubles.teardown
  result
end
