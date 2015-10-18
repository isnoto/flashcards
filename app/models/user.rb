class User < ActiveRecord::Base
  has_many :cards

  authenticates_with_sorcery!

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates :password,
            length: { minimum: 3 },
            confirmation: true
  validates :email, :name,
            uniqueness: true,
            presence: true
  validates :email, format: EMAIL_REGEX
end
