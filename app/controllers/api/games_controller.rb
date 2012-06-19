class Api::GamesController < Api::ApplicationController
  version 1

  before_filter :restrict_access, except: [:index, :new, :create]

  # GET /games
  # GET /games.json
  def index
    expose Game.all
  end

  # GET /:game_title
  # GET /:game_title.json
  def show
    expose Game.where(title: params[:game_title]).first
  end

  # GET /:game_title/new
  # GET /:game_title/new.json
  def new
    expose Game.new(title: params[:game_title])
  end

  # POST /:game_title
  # POST /:game_title.json
  def create
    @game = Game.new(title: params[:game_title])
    if @game.valid?
      @game.save!
      expose @game, status: :created
    else
      expose @game.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /:game_title/1
  # PATCH/PUT /:game_title/1.json
  def update
    @game = Game.where(title: params[:game_title]).first
    game_params = params.reject {|x| x.match /action|controller|version/ }

    if @game.update_attributes(game_params)
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  # DELETE /:game_title
  def destroy
    @game = Game.where(title: params[:game_title]).first
    @game.destroy

    head :no_content
  end

end
