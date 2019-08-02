Alors('une accélération de {int}% doit être envoyée à la voiture') do |amount|
  @find_another_name.call

  Async do |task|
    task.sleep 2
    expect(CisDoubles.announces).to include(topic: 'cockpit/0/car/throttle', message: (amount * 32_767 / 100).to_s)
  end
end

Alors('un message contenant la valeur de gaz doit être envoyé') do
  step 'une accélération de 25% doit être envoyée à la voiture'
end
