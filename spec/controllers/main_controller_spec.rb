require 'spec_helper'

describe MainController do
  it 'should inherit from application controller' do
    controller.class.superclass.should == ApplicationController
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

end
