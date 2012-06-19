require 'spec_helper'

describe "Games" do
  def valid_attributes
    {:title => SecureRandom.hex, scores: [1, 5, 3, 2, 4] }
  end
  describe "GET /games" do
    it "should return a list of all the games" do
      get '1/games'
      response.status.should be(200)
    end
  end

  describe "GET /GAME_TITLE/new" do
    it "should make me a new game" do
      game = Game.create! valid_attributes
      get "1/#{game.title}/new"
      response.status.should be(200)
    end
  end

  describe "Creating a new game"  do
    describe "POST /GAME_TITLE" do
      describe "Valid Game" do
        before(:each) do
          @game_title = SecureRandom.hex
          post "1/#{@game_title}"
        end
        it "should create me a new game" do
          response.status.should be(201)
        end
        it "should return me an access token for the new game that is created" do
          game = Game.where(title: @game_title).first
          response.body.should include('access_token')
          response.body.should include(game.access_token)
        end
        it "should return me the id of the response" do
          game = Game.where(title: @game_title).first
          response.body.should include('_id')
          response.body.should include(game.id.to_s)
        end
        it "should return me the title of the game" do
          response.body.should include("title")
          response.body.should include(@game_title)
        end
      end

      describe "Invalid Game" do
        before(:each) do
          @game_title = SecureRandom.hex
          2.times { post "1/#{@game_title}" }
        end
        it "should not create me a new game" do
          response.status.should be(422)
        end
        it "should return the title of the response" do
          response.body.should include("title")
          response.body.should include("is already taken")
        end
      end
    end
  end

  describe "GET /GAME_TITLE?access_token=ACCESS_TOKEN" do
    before(:each) do
      @game = Game.create! valid_attributes
    end
    it "should show me the game I am requesting" do
      access_token = @game.access_token
      get "1/#{@game.title}?access_token=#{access_token}"
      response.status.should be(200)
    end
    it "should show me the game id" do
      access_token = @game.access_token
      get "1/#{@game.title}?access_token=#{access_token}"
      response.body.should include('_id')
      response.body.should include(@game.id.to_s)
    end
    it "should show me the access token" do
      access_token = @game.access_token
      get "1/#{@game.title}?access_token=#{access_token}"
      response.body.should include('access_token')
      response.body.should include(@game.access_token)
    end
    it "should show me the title of the game" do
      access_token = @game.access_token
      get "1/#{@game.title}?access_token=#{access_token}"
      response.body.should include('title')
      response.body.should include(@game.title)
    end
    it "should show me the custom key value pair" do
      access_token = @game.access_token
      @game.update_attribute :new_key, 'new_value'
      get "1/#{@game.title}?access_token=#{access_token}"
      response.body.should include('new_key')
      response.body.should include(@game.new_key)
    end
    it "should unauthorize me for having an incorrect access_token" do
      access_token = 1
      get "1/#{@game.title}?access_token=#{access_token}"
      response.status.should be(401)
    end
    it "should unauthorize me for having an incorrect game" do
      game_title = SecureRandom.hex
      access_token = 1
      get "1/#{game_title}?access_token=#{access_token}"
      response.status.should be(401)
    end
  end

  describe "PUT /GAME_TITLE" do
    before(:each) do
      @game = Game.create! valid_attributes
      @access_token = @game.access_token
    end
    it "should update the game for me" do
      put "1/#{@game.title}?access_token=#{@access_token}"
      response.status.should be(204)
    end
    it "should update the game for me with a custom key value pair" do
      put "1/#{@game.title}?access_token=#{@access_token}", {:new_key => 'some_value'}
      request.params.should include('new_key' => 'some_value')
      response.status.should be(204)
    end
    it "should not be able to update the game title" do
      put "1/#{@game.title}?access_token=#{@access_token}", :game_title => 'NewTitle'
      response.status.should be(204)
    end
    it "should not update the game for me with invalid credentials" do
      put "1/#{@game.title}?access_token=1"
      response.status.should be(401)
    end
  end

  describe "DELETE /GAME_TITLE" do
    before(:each) do
      @game = Game.create! valid_attributes
      @access_token = @game.access_token
    end
    it "should delete the game for me" do
      delete "1/#{@game.title}?access_token=#{@access_token}"
      response.status.should be(204)
    end
    it "should not delete the game for me with invalid credentials" do
      delete "1/#{@game.title}?access_token=1"
      response.status.should be(401)
    end
  end

end
