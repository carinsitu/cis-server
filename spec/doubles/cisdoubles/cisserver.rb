module CisServer
  class Master
    def self.announce(topic, message)
      CisDoubles.announces << { topic: topic, message: message }
    end
  end
end
