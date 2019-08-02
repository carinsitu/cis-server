Et('un serveur lancé') do
  @master = CisServer::Master.new '127.0.0.1'
  @master.run
end

Et('une voiture appairée') do
  @car = CisDoubles::EmulatedCar.new
  @car.connect
end

Et('un controlleur appairé') do
  @game_controller = CisDoubles::EmulatedGameController.new
end
