require "spec_helper"

describe Api::GamesController do
  describe "routing" do
    before(:each) do
      @version = "1"
    end

    def valid_params(options={})
      { format: "json",
        controller: "games",
        action: options[:action],
        version: @version,
        game_title: "skyrim"}
    end

    it "routes to #index" do
      get("#{@version}/games").should route_to("api/games#index", { format: "json", controller: "games", action: "index",version: @version})
    end

    it "routes to #new" do
      get("#{@version}/skyrim/new").should route_to("api/games#new", valid_params(action: "new"))
    end

    it "routes to #show" do
      get("#{@version}/skyrim").should route_to("api/games#show", valid_params(action: "show"))
    end

    it "routes to #create" do
      post("#{@version}/skyrim").should route_to("api/games#create", valid_params(action: "create"))
    end

    it "routes to #update" do
      put("#{@version}/skyrim").should route_to("api/games#update", valid_params(action: "update"))
    end

    it "routes to #destroy" do
      delete("#{@version}/skyrim").should route_to("api/games#destroy", valid_params(action: "destroy"))
    end

  end
end
