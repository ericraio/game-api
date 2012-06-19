require 'spec_helper'

describe Api::ApplicationController do

  it "should inherit from ActionController::Base" do
    controller.class.superclass.should eq(RocketPants::Base)
  end

  describe "#restrict_access" do
    it "should grant access if you have an access token" do
      @game = [mock("Game", title: "League")]
      controller.params = { access_token: "token", game_title: "League" }
      Game.should_receive(:where).with(access_token: "token").and_return(@game)
      @game.should_receive(:exists?).and_return(true)
      controller.send(:restrict_access).should be_nil
    end 
    it "should memoize the api key" do
      Game.should_not_receive(:where)
      @game = mock("Game", title: "League")
      controller.params = { game_title: "League" }
      controller.instance_variable_set(:@game, @game)
      controller.send(:restrict_access).should be_nil
    end 
    it "should not grant access" do
      Game.should_not_receive(:where)
      controller.should_receive(:head).with(:unauthorized).and_return('unauthorized')
      controller.send(:restrict_access).should eq('unauthorized')
    end 
  end 

  describe "#authenticated" do
    it "should return the restrict access method" do
      controller.should_receive(:restrict_access)
      controller.send(:authenticated).should be_nil
    end
  end
end
