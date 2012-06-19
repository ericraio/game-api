require 'spec_helper'

describe Player do
  it "should include RocketPants::Cacheable" do
    Game.should include(RocketPants::Cacheable)
  end
  it "should include Mongoid::Document" do
    Player.should include(Mongoid::Document)
  end

  it { should have_field(:screen_name).of_type(String) }
  it { should have_field(:last_logged_in).of_type(DateTime)}
  it { should have_field(:email).of_type(String)}
  it { should be_embedded_in(:game) }

  it { should validate_presence_of(:screen_name) }
  it { should validate_uniqueness_of(:screen_name) }

  it { should validate_uniqueness_of(:email) }
  it { should validate_format_of(:email).with_format(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i) }
end
