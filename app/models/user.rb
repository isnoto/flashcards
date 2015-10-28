class User < ActiveRecord::Base
  has_many :cards, through: :decks, dependent: :destroy
  has_many :authentications, dependent: :destroy
  has_many :decks

  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  accepts_nested_attributes_for :authentications

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates :password,
            length: { minimum: 3 },
            confirmation: true
  validates :email, :name,
            uniqueness: true,
            presence: true
  validates :email, format: { with: EMAIL_REGEX }
end
