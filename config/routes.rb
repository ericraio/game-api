CorePlatform::Application.routes.draw do
  root to: "main#index"

  resources :games

  api version: 1 do
    # Game Routes
    get     '/games'            => 'api/games#index',     :as => :games_index
    get     '/:game_title'      => 'api/games#show',      :as => :games_show
    get     '/:game_title/new'  => 'api/games#new',       :as => :games_new
    post    '/:game_title'      => 'api/games#create',    :as => :games_create
    put     '/:game_title'      => 'api/games#update',    :as => :games_update
    delete  '/:game_title'      => 'api/games#destroy',   :as => :games_destroy

    # Player Routes
    get     '/:game_title/players'                  => 'api/players#index',   :as => :players_index
    get     '/:game_title/player/:screen_name/new'  => 'api/players#new',     :as => :players_new
    post    '/:game_title/player/:screen_name'      => 'api/players#create',  :as => :players_create
    get     '/:game_title/player/:screen_name'      => 'api/players#show',    :as => :players_show
    put     '/:game_title/player/:screen_name'      => 'api/players#update',  :as => :players_update
    delete  '/:game_title/player/:screen_name'      => 'api/players#destroy', :as => :players_destroy
  end

end
