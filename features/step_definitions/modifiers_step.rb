Étantdonnéque("le joueur n'a pas de bonus") do
  @master
    .instance_variable_get(:@cockpit_manager)
    .instance_variable_get(:@cockpits)[0]
    .instance_variable_set :@modifiers, []
end

Étantdonnéque('le joueur a {int} bonus de boost') do |amount|
  amount.times do
    @master
      .instance_variable_get(:@cockpit_manager)
      .instance_variable_get(:@cockpits)[0]
      .send :add_modifier, :Boost
  end
end
