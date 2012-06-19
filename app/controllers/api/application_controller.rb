class Api::ApplicationController < RocketPants::Base

  private

   def restrict_access
     if !@game && params[:access_token]
       game = Game.where(access_token: params[:access_token])
       @game = game.first if game.exists?
     end
     head :unauthorized unless @game && @game.title == params[:game_title]
   end

   def authenticated
     restrict_access
   end
end
