require 'spec_helper'
Mongoid.observers = GameObserver
Mongoid.instantiate_observers

describe GameObserver do

  def valid_attributes
    { title: SecureRandom.hex }
  end

  it "should inherit from Mongoid::Observer" do
    GameObserver.superclass.should eql(Mongoid::Observer)
  end

  describe "#after create" do
    it "should create an access_token" do
      game = Game.create! title: SecureRandom.hex
      game.access_token.should_not be_nil
    end
  end

end
