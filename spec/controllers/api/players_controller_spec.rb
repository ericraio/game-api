require 'spec_helper'

describe Api::PlayersController do
  it 'should inherit from application controller' do
    controller.class.superclass.should == Api::ApplicationController
  end

  def valid_attributes(n=0)
    { game_title: "Skyrim", version: 1, screen_name: SecureRandom.hex + n.to_s, email: "#{SecureRandom.hex}@gmail.com", score: "#{n}" }
  end

  def valid_session
    {}
  end

  before(:each) do
    @game = Game.create! :title => SecureRandom.hex
    controller.stub(:restrict_access).and_return(nil)
    controller.instance_variable_set(:@game, @game)
  end

  describe "GET index" do
    before(:each) do
      5.times { |n|
        @player = @game.players.create!(valid_attributes(n)).screen_name
      }
    end
    describe "before_filters" do
      before(:each) do
        @params = { version: 1, game_title: "Skyrim" }
      end
      it "should receive restrict access before filter" do
        controller.should_receive(:restrict_access)
        get :index, @params, valid_session
      end
    end

    it "returns all players for the game" do
      params = { version: 1, game_title: "Skyrim", access_token: "something" }

      get :index, params, valid_session
      response.status.should eql(200)
    end
    it "should limit the how many players there is" do
      params = { version: 1, limit: 2, game_title: "Skyrim", access_token: "something" }

      get :index, params, valid_session
      json = JSON.parse(response.body)

      json["response"].size.should eql(2)
    end
    it "should sort the results ASC and limit the results by 1" do
      get :index, {version: 1, game_title: "Skyrim", limit: 1, order: "score ASC"}, valid_session
      json = JSON.parse(response.body)
      json["response"]["score"].should eql("0")
    end
    it "should sort the results DESC and limit the results by 1" do
      get :index, {version: 1, game_title: "Skyrim", limit: 1, order: "score DESC"}, valid_session
      json = JSON.parse(response.body)
      json["response"]["score"].should eql("4")
    end
  end

  describe "GET show" do
    it "assigns the requested player as @player" do
      player = @game.players.create! valid_attributes
      get :show, valid_attributes, valid_session
      response.status.should eql(200)
    end
  end

  describe "GET new" do
    describe "before_filters" do
      after(:each) do
        get :new, valid_attributes, valid_session
      end
      it "should receive restrict access before filter" do
        controller.should_receive(:restrict_access)
      end
    end
    it "sets up and returns a new player" do
      get :new, valid_attributes, valid_session
      response.status.should eql(200)
    end
  end

  describe "POST create" do
    describe "before_filters" do
      after(:each) do
        post :create, valid_attributes, valid_session
      end
      it "should receive restrict access before filter" do
        controller.should_receive(:restrict_access)
      end
    end
    describe "with valid params" do
      it "creates a new Player" do
        post :create, valid_attributes, valid_session
        response.status.should eql(201)
      end
    end
  end

  describe "PUT update" do
    describe "before_filters" do
      before(:each) do
        @player = @game.players.create! valid_attributes
        controller.instance_variable_set(:@player, @player)
      end
      it "should receive restrict access before filter" do
        controller.should_receive(:restrict_access)
        put :update, valid_attributes, valid_session
      end
    end
    describe "with valid params" do
      before(:each) do
        @player = @game.players.create! valid_attributes.merge score: "50"
        controller.instance_variable_set(:@player, @player)
        @params = { :version => 1,
                    :game_title => "Skyrim",
                    :id => @player.to_param,
                    :player => valid_attributes }

      end
      it "updates the requested game" do
        params = {  :version => 1,
                    :game_title => "Skyrim",
                    :id => @player.to_param,
                    :screen_name => @player.screen_name.to_param, 
                    :player => {'these' => 'params'} }

        put :update, params, valid_session
      end
      it "redirects to the player" do
        put :update, valid_attributes, valid_session
        response.status.should eq(204)
      end
      it "should update the player with any number of attributes give" do
        put :update, valid_attributes, valid_session
        response.status.should eq(204)
      end
    end
    describe "invalid params" do
      before(:each) do
        @player = @game.players.create! valid_attributes
        controller.instance_variable_set(:@player, @player)
        @player.should_receive(:update_attributes).and_return(false)
      end
      it "should return back a status code of 422" do
        put :update, valid_attributes, valid_session
        response.status.should eq(422)
      end
    end
  end

  describe "DELETE destroy" do
    describe "before_filters" do
      after(:each) do
        player = @game.players.create! valid_attributes
        delete :destroy, {:version => 1, game_title: @game.title, screen_name: player.screen_name.to_param}, valid_session
      end
      it "should receive restrict access before filter" do
        controller.should_receive(:restrict_access)
      end
    end
    it "returned status should be 204" do
      player = @game.players.create! valid_attributes
      delete :destroy, {:version => 1, game_title: @game.title, screen_name: player.screen_name.to_param}, valid_session
      response.status.should eql(204)
    end
  end

end
