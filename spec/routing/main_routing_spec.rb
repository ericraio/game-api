require 'spec_helper'

describe MainController do
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
      get("/").should route_to("main#index")
    end

  end

end
