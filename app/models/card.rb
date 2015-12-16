class Card < ActiveRecord::Base
  belongs_to :user
  belongs_to :deck

  attr_accessor :deck_name

  mount_uploader :image, ImageUploader

  before_validation :add_review_date, if: :new_record?

  validates :original_text, :translated_text, :review_date,
            presence: true
  validates :deck_name, presence: true, if: :deck_name
  validate :words_cannot_be_equal

  scope :for_review,        -> { where('review_date <= ?', Time.zone.now) }
  scope :random_for_review, -> { for_review.offset(rand(for_review.count)) }

  def check_answer(answer, time)
    result = SuperMemo.new(e_factor, answer, original_text, repetitions_number,
                           time, interval).calculate_interval
    update(result.except(:comparison_result))

    result[:comparison_result]
  end

  def self.create_card_in_deck(user, params)
    deck = find_or_create_deck(params[:deck_name], user)

    deck.cards.build(params)
  end

  private

  def prepare_word(word)
    word.squish.mb_chars.downcase.to_s
  end

  def words_cannot_be_equal
    if prepare_word(original_text) == prepare_word(translated_text)
      errors.add(:original_text, "can't be equal Translated text")
      errors.add(:translated_text, "cant't be equal Original text")
    end
  end

  def add_review_date
    self.review_date = Time.zone.now
  end

  def self.find_or_create_deck(deck_name, user)
    deck = user.decks.find_by(name: deck_name)

    deck || user.decks.create(name: deck_name)
  end
end
