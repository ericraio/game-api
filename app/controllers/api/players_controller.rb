class Api::PlayersController < Api::ApplicationController
  version 1

  before_filter :restrict_access

  def index
    if params[:limit] and params[:order]
      order = params[:order].split(/(\w+)/)
      query = order[1].to_sym
      if order.last.match(/[A|a][S|s][C|c]/)
        return expose @game.players.asc(query).limit(params[:limit].to_i).first
      elsif order.last.match(/[D|d][E|e][S|s][C|c]/)
        return expose @game.players.desc(query).limit(params[:limit].to_i).last
      end
    end

    return expose @game.players.limit(params[:limit].to_i) if params[:limit] and !params[:sort]
    expose @game.players
  end

  def show
    expose @game.players.where(screen_name: params[:screen_name] ).first
  end

  def new
    expose @game.players.new params
  end

  def create
    player_params = params.reject { |x| x.match /controller|action|version/ }
    @player = @game.players.new(player_params)

    if @player.valid?
      @player.save!
      expose @player, status: :created
    else
      expose @player.errors, status: :unprocessable_entity
    end
  end

  def update
    @player ||= @game.players.where(screen_name: params[:screen_name]).first

    if @player.update_attributes(params)
      head :no_content
    else
      expose @player.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @player = @game.players.where(screen_name: params[:screen_name]).first
    head :no_content if @player.destroy
  end

end
