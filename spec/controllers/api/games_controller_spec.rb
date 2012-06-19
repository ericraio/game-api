require 'spec_helper' 

describe Api::GamesController do
  it 'should inherit from application controller' do
    controller.class.superclass.should == Api::ApplicationController
  end

  # This should return the minimal set of attributes required to create a valid
  # Game. As you add validations to Game, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    title = SecureRandom.hex
    {:game_title => title, :title => title }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # GamesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  before(:each) do
    controller.stub(:restrict_access).and_return(nil)
  end

  describe "GET index" do
    describe "before_filters" do
    end
    it "returns all the games" do
      games = Game.count
      get :index, { version: 1 }, valid_session
      JSON.parse(response.body)["response"].size.should == games
    end
  end
  describe "GET show" do
    describe "before_filters" do
      after(:each) do
        game = Game.create! valid_attributes
        get :show, { version: 1,
                     game_title: game.title.to_param }, valid_session
      end
      it "should receive before_filter restrict_access" do
        controller.should_receive(:restrict_access)
      end
    end
  end

  describe "GET new" do
    describe "before_filters" do
      after(:each) do
        params = { version: 1, game_title: "Skyrim" }

        get :new, params, valid_session
      end
      it "should not receive before_filter restrict_access" do
        controller.should_not_receive(:restrict_access)
      end
    end
  end

  describe "POST create" do
    describe "before_filters" do
      after(:each) do
        post :create, valid_attributes, valid_session
      end
    end

    describe "with valid params" do
      it "creates a new Game" do
        expect {
          params = { game_title: SecureRandom.hex,
                     version: 1,
                     game: valid_attributes}

          post :create, params, valid_session
        }.to change(Game, :count).by(1)
      end

      it "redirects to the created game" do
        params = { game_title: SecureRandom.hex,
                   version: 1,
                   game: valid_attributes}

        post :create, params, valid_session
        response.status.should eq(201)
      end
    end
  end

  describe "PUT update" do
    describe "before_filters" do
      after(:each) do
        game = Game.create! valid_attributes
        params = {  game_title: game.title.to_param,
                    version: 1 }

        put :update, params, valid_session
      end
      it "should receive before_filter restrict_access" do
        controller.should_receive(:restrict_access)
      end
    end
    describe "with valid params" do
      it "updates the requested game" do
        game = Game.create! valid_attributes
        params = {  game_title: game.title.to_param,
                    these: 'params',
                    version: 1 }

        # Assuming there are no other games in the database, this
        # specifies that the Game created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Game.any_instance.should_receive(:update_attributes).with({'game_title' => game.title, 'these' => 'params'})
        put :update, params, valid_session
      end

      it "redirects to the game" do
        game = Game.create! valid_attributes
        params = { game_title: game.title.to_param,
                   version: 1 }

        put :update, params, valid_session
        response.status.should eq(204)
      end
    end

    describe "with invalid params" do
      it "returns status 422" do
        game = Game.create! valid_attributes
        params = { game_title: game.title.to_param,
                   version: 1 }

        # Trigger the behavior that occurs when invalid params are submitted
        Game.any_instance.stub(:save).and_return(false)
        put :update, params, valid_session
        response.status.should == 422
      end
    end
  end

  describe "DELETE destroy" do
    describe "before_filters" do
      after(:each) do
        game = Game.create! valid_attributes
        params = { game_title: game.title.to_param,
                   version: 1 }
        delete :destroy, params, valid_session
      end
      it "should receive before_filter restrict_access" do
        controller.should_receive(:restrict_access)
      end
    end
    it "destroys the requested game" do
      game = Game.create! valid_attributes
      expect {
        params = { game_title: game.title.to_param,
                   version: 1 }

        delete :destroy, params, valid_session
      }.to change(Game, :count).by(-1)
    end
    it "redirects to the games list" do
      game = Game.create! valid_attributes
      params = { game_title: game.title.to_param,
                 version: 1 }

      delete :destroy, params, valid_session
      response.status.should == 204
    end
  end

end
