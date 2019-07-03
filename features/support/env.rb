require 'rspec'
require 'cucumber/rspec/doubles'

require 'cisserver'

require_relative '../../spec/mocks/cismocks'
require_relative '../../spec/mocks/emulatedcar'
require_relative '../../spec/mocks/emulatedgamepad'
require_relative '../../spec/mocks/emulatedgamecontroller'

Before do
  CisMocks.setup
end
