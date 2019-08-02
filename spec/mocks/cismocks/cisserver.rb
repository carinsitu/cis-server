module CisServer
  class Master
    def self.announce(topic, message)
      CisMocks.announces << { topic: topic, message: message }
    end
  end
end
