Quand('le joueur accélère de {int}%') do |amount|
  # Move right trigger (ie. axis 5) to value: 24042
  @find_another_name = -> { @game_controller.move_forward amount / 100 }
end

Quand("j'appuie sur le bouton pour avancer") do
  step 'le joueur accélère de 100%'
end
