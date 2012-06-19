require "spec_helper"

describe Api::PlayersController do
  describe "routing" do
    before(:each) do
      @version = "1"
    end

    def valid_params(options={})
      { format: "json",
        controller: "players",
        action: options[:action],
        version: @version,
        screen_name: "noesis",
        game_title: "skyrim"}
    end

    it "routes to #index" do
      get("#{@version}/skyrim/players").should route_to("api/players#index", { format: "json", controller: "players", action: "index", version: @version, game_title: "skyrim"})
    end

    it "routes to #new" do
      get("#{@version}/skyrim/player/noesis/new").should route_to("api/players#new", valid_params(action: "new"))
    end

    it "routes to show" do
     get("#{@version}/skyrim/player/noesis").should route_to("api/players#show", valid_params(action: "show"))
    end

    it "routes to #update" do
      put("#{@version}/skyrim/player/noesis").should route_to("api/players#update", valid_params(action: "update"))
    end

    it "routes to #create" do
      post("#{@version}/skyrim/player/noesis").should route_to("api/players#create", valid_params(action: "create"))
    end

    it "routes to #destroy" do
      delete("#{@version}/skyrim/player/noesis").should route_to("api/players#destroy", valid_params(action: "destroy"))
    end

  end
end
