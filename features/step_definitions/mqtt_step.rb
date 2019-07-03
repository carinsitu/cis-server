Alors('une accélération de {int}% doit être envoyée à la voiture') do |amount|
  expect(@master.class).to receive(:announce).with('cockpit/0/car/throttle', (amount * 32_767 / 100).to_s)

  @find_another_name.call
end

Alors('un message contenant la valeur de gaz doit être envoyé') do
  step 'une accélération de 25% doit être envoyée à la voiture'
end
