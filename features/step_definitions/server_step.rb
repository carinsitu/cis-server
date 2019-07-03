Et('un serveur lancé') do
  @master = CisServer::Master.new
end

Et('une voiture appairée') do
  @car = CisMocks::EmulatedCar.new @master
end

Et('un controlleur appairé') do
  @game_controller = CisMocks::EmulatedGameController.new @master
end
