class User < ActiveRecord::Base
  has_many :cards, through: :decks, dependent: :destroy
  has_many :authentications, dependent: :destroy
  has_many :decks

  belongs_to :current_deck, class_name: Deck

  before_create :set_locale

  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  accepts_nested_attributes_for :authentications

  EMAIL_REGEXP = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates :password,
            length: { minimum: 3 },
            confirmation: true, if: :password
  validates :password_confirmation, presence: true,
            if: :password
  validates :name, presence: true
  validates :email, uniqueness: true,
            presence: true,
            format: { with: EMAIL_REGEXP },
            if: :email

  def random_card
    if current_deck
      current_deck.cards.random_for_review.first
    else
      cards.random_for_review.first
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

  def set_locale
    self.locale = I18n.locale
  end

  def available_locales
    I18n.available_locales.map(&:to_s)
  end
end
