class Card < ActiveRecord::Base
  before_validation :add_review_date, if: :new_record?
  validates :original_text, :translated_text, :add_review_date, presence: true
  validate :words_cannot_be_equal

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
