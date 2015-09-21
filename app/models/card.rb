class Card < ActiveRecord::Base
  after_validation :validate_text, :add_review_date, if: :new_record?
  validates :original_text, :translated_text, presence: true


  private

  def validate_text
    original_text.downcase != translated_text.downcase
  end

  def add_review_date
    self.review_date = Time.now + 3.days
  end
end
