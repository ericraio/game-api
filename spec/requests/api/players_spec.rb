require 'spec_helper'


describe "Players ->" do
  def valid_attributes(n=0)
    { screen_name: SecureRandom.hex + n.to_s, email: "#{SecureRandom.hex}@gmail.com", score: "#{n}" }
  end

  before(:each) do
    @game = Game.create!(title: SecureRandom.hex)
    @access_token = @game.access_token
    @player = @game.players.create!(valid_attributes).screen_name
  end

  describe "Viewing all the players" do
    describe "GET /GAME_TITLE/players" do
      it "should return a list of all the players from this game" do
        get "1/#{@game.title}/players?access_token=#{@access_token}"
        response.status.should be(200)
      end
      it "should include a count in the response" do
        get "1/#{@game.title}/players?access_token=#{@access_token}"
        response.body.should include("count")
        response.body.should include("1")
      end
      it "should not allow me to see the list of players with a wrong access_token" do
        get "1/#{@game.title}/players?access_token=1"
        response.status.should be(401)
      end
      it "should not allow me to see the list of players with out an access_token" do
        get "1/#{@game.title}/players"
        response.status.should be(401)
      end
    end
  end

  describe "Making a new player object" do
    describe "GET /GAME_TITLE/player/SCREEN_NAME/new" do
      it "should make me a new player for the game" do
        get "1/#{@game.title}/player/atrosity/new?access_token=#{@access_token}"
        response.status.should be(200)
      end
      it "should return me the players ID" do
        get "1/#{@game.title}/player/atrosity/new?access_token=#{@access_token}"
        id = JSON.parse(response.body)["_id"].to_s
        response.body.should include('_id')
        response.body.should include(id)
      end
      it "should return me the players screen_name" do
        get "1/#{@game.title}/player/atrosity/new?access_token=#{@access_token}"
        response.body.should include('screen_name')
        response.body.should include('atrosity')
      end
      it "should return me the players custom params" do
        get "1/#{@game.title}/player/atrosity/new?access_token=#{@access_token}", {new_key: 'some_value', new_key2: 'some_value2'}
        response.body.should include('new_key')
        response.body.should include('some_value')
        response.body.should include('new_key2')
        response.body.should include('some_value2')
      end
      it "should not make me a new player for the game with invalid credentials" do
        get "1/#{@game.title}/player/atrosity/new?access_token=1"
        response.status.should be(401)
      end
      it "should not make me a new player for the game with out an access_token" do
        get "1/#{@game.title}/player/atrosity/new"
        response.status.should be(401)
      end
    end
  end

  describe "Creating a new player" do
    describe "POST /GAME_TITLE/player/SCREEN_NAME?access_token=ACCESS_TOKEN" do
      describe "creating a new player"  do
        before(:each) do
          post "1/#{@game.title}/player/atrosity?access_token=#{@access_token}", email: "#{SecureRandom.hex}@gmail.com"
        end
        it "should create me a new player for the game" do
          response.status.should be(201)
        end
        it "should respond with the _id" do
          id = JSON.parse(response.body)["id"].to_s
          response.body.should include('_id')
          response.body.should include(id)
        end
        it "should respond with the email field" do
          post "1/#{@game.title}/player/atrosity1?access_token=#{@access_token}"
          email = JSON.parse(response.body)["email"]
          email.should be_nil
        end
        it "should respond with the email" do
          email = JSON.parse(response.body)["email"].to_s
        end
        it "should respond with the last logged in" do
          post "1/#{@game.title}/player/atrosity2?access_token=#{@access_token}", last_logged_in: Time.now
          last_logged_in = JSON.parse(response.body)["last_logged_in"]
          last_logged_in.should be_nil
        end
        it "should respond with the screen_name" do
          response.body.should include('screen_name')
          response.body.should include('atrosity')
        end
        it "should respond with custom key values" do
          post "1/#{@game.title}/player/atrosity2?access_token=#{@access_token}", email: "#{SecureRandom.hex}@gmail.com", new_key: 'some_value', new_key2: 'some_value2'
          response.body.should include('new_key')
          response.body.should include('value')
          response.body.should include('new_key2')
          response.body.should include('value2')
        end
        it "should not respond with the controller" do
          response.body.should_not include('controller')
        end
        it "should not respond with the action" do
          response.body.should_not include('action')
        end
        it "should not respond with the version" do
          response.body.should_not include('version')
        end
      end
      describe "not creating a new player" do
        it "should not create me a new player for the game with invalid credentials" do
          post "1/#{@game.title}/player/atrosity?access_token=1"
          response.status.should be(401)
        end
        it "should not create me a new player for the game without an access_token" do
          post "1/#{@game.title}/player/atrosity"
          response.status.should be(401)
        end
      end
    end
  end

  describe "Viewing Player Data" do
    describe "GET /GAME_TITLE/player/SCREEN_NAME?access_token=ACCESS_TOKEN" do
      it "should show me a player from the game" do
        get "1/#{@game.title}/player/#{@player}?access_token=#{@access_token}"
        response.status.should be(200)
      end
      it "should respond with the id" do
        get "1/#{@game.title}/player/#{@player}?access_token=#{@access_token}"
        id = JSON.parse(response.body)['_id'].to_s
        response.body.should include('_id')
        response.body.should include(id)
      end
      it "should respond with the screen name" do
        get "1/#{@game.title}/player/#{@player}?access_token=#{@access_token}"
        response.body.should include('screen_name')
        response.body.should include(@player)
      end
      it "should respond with last logged in" do
        get "1/#{@game.title}/player/#{@player}?access_token=#{@access_token}"
        response.body.should include('last_logged_in')
        response.body.should include('')
      end
      it "should not show me a player because of bad credentials" do
        get "1/#{@game.title}/player/#{@player}?access_token=1"
        response.status.should be(401)
      end
      it "should not show me a player for not having an access_token at all" do
        get "1/#{@game.title}/player/#{@player}"
        response.status.should be(401)
      end
    end
  end

  describe "Changing Player Data" do
    describe "PUT /GAME_TITLE/player/SCREEN_NAME?access_token=ACCESS_TOKEN" do
      it "should update a player for the game" do
        put "1/#{@game.title}/player/#{@player}?access_token=#{@access_token}"
        response.status.should be(204)
      end
      it "should update a player with custom key values" do
        put "1/#{@game.title}/player/#{@player}?access_token=#{@access_token}", new_key: 'new_value'
        response.status.should be(204)
      end
      it "should not update a player for the game with invalid credentials" do
        put "1/#{@game.title}/player/atrosity?access_token=1"
        response.status.should be(401)
      end
      it "should not update a player for the game without an access_token" do
        put "1/#{@game.title}/player/atrosity"
        response.status.should be(401)
      end
    end
  end

  describe "Deleting Player Data"  do
    describe "DELETE/GAME_TITLE/player/SCREEN_NAME?access_token=ACCESS_TOKEN" do
      it "should delete a player for the game" do
        delete "1/#{@game.title}/player/#{@player}?access_token=#{@access_token}"
        response.status.should be(204)
      end
      it "should not delete a player for the game with invalid credentials" do
        delete "1/#{@game.title}/player/atrosity?access_token=1"
        response.status.should be(401)
      end
      it "should not delete a player for the game without an access_token" do
        delete "1/#{@game.title}/player/atrosity"
        response.status.should be(401)
      end
    end
  end

  describe "Querying Data" do
    before(:each) do
      5.times { |n|
        @player = @game.players.create!(valid_attributes(n)).screen_name
      }
    end
    it "should limit the data for any given attribute" do
      get "1/#{@game.title}/players?access_token=#{@access_token}", limit: 2
      json = JSON.parse(response.body)
      json["response"].size.should eql(2)
    end
    it "sort the data ASC on any given attribute" do
      get "1/#{@game.title}/players?access_token=#{@access_token}", { limit: 1, order: 'score ASC' }
      json = JSON.parse(response.body)
      json["response"]["score"].should eql("0")
    end
    it "sort the data DESC on any given attribute" do
      get "1/#{@game.title}/players?access_token=#{@access_token}", { limit: 1, order: 'score DESC' }
      json = JSON.parse(response.body)
      json["response"]["score"].should eql("4")
    end
  end

end
