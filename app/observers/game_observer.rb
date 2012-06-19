class GameObserver < Mongoid::Observer
  observe :game

  def after_create(game)
    game.update_attribute :access_token, SecureRandom.hex
  end

end
