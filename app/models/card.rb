class Card < ActiveRecord::Base
  belongs_to :user
  belongs_to :deck

  attr_accessor :deck_name

  mount_uploader :image, ImageUploader

  before_validation :add_review_date, if: :new_record?
  validates :original_text, :translated_text, :review_date, :deck_id,
            presence: true
  validate :words_cannot_be_equal

  scope :condition,         -> { where('review_date <= ?', Time.now) }
  scope :random_for_review, -> { condition.offset(rand(condition.count)) }

  def check_answer(answer)
    result = prepare_word(answer) == prepare_word(original_text)

    update_attributes(review_date: add_review_date) if result
  end

  def self.random_card(user_id)
    user = User.find_by(id: user_id)

    if user.current_deck_id
      find_current_deck(user).cards.random_for_review.first
    else
      user.random_for_review.first
    end
  end

  def self.find_current_deck(user)
    user.decks.find(user.current_deck_id)
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
    self.review_date = Time.now + 3.days
  end
end
