class Game
  include RocketPants::Cacheable
  include Mongoid::Document
  field :title, :type => String
  field :access_token, :type => String

  embeds_many :players
  validates :title, presence: true, uniqueness: true
end
