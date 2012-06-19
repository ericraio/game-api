class Player
  include RocketPants::Cacheable
  include Mongoid::Document
  field :screen_name, :type => String
  field :email, :type => String
  field :last_logged_in, :type => DateTime

  embedded_in :game

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, allow_blank: true }, uniqueness: true
  validates :screen_name, presence: true, uniqueness: true


end
