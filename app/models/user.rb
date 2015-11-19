class User < ActiveRecord::Base
  has_many :cards, through: :decks, dependent: :destroy
  has_many :authentications, dependent: :destroy
  has_many :decks

  belongs_to :current_deck, class_name: Deck

  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  accepts_nested_attributes_for :authentications

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates :password,
            length: { minimum: 3 },
            confirmation: true, if: :password
  validates :password_confirmation, presence: true,
            if: :password
  validates :name, uniqueness: true,
            presence: true
  validates :email, uniqueness: true,
            presence: true,
            format: { with: EMAIL_REGEX },
            if: :email

  def random_card
    user = User.find(self.id)

    if user.current_deck
      user.current_deck.cards.random_for_review.first
    else
      user.cards.random_for_review.first
    end
  end

  def self.notify_pending_cards
    User.pending_cards.find_each do |user|
      CardsMailer.pending_cards_notification(user).deliver_now
    end
  end

  def self.pending_cards
    User.joins(:cards).where.not(email: nil).merge(Card.for_review).uniq
  end
end
