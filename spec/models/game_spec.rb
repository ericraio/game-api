require 'spec_helper'

describe Game do
  it "should include RocketPants::Cacheable" do
    Game.should include(RocketPants::Cacheable)
  end
  it "should include Mongoid::Document" do
    Game.should include(Mongoid::Document)
  end
  it { should have_field(:title).of_type(String) }
  it { should have_field(:access_token).of_type(String) }

  it { should embed_many(:players) }

  it { should validate_presence_of(:title) }
  it { should validate_uniqueness_of(:title) }

  def valid_attributes
    {title: SecureRandom.hex }
  end
end
