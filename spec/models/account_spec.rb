require 'spec_helper'

describe Account do
  it "should include Mongoid::Document" do
    Account.should include(Mongoid::Document)
  end
  it { should have_field(:name).of_type(String) }

  it { should have_many(:users) }
end
