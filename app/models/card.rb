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

  scope :condition,         -> { where('review_date <= ?', Time.now) }
  scope :random_for_review, -> { condition.offset(rand(condition.count)) }

  def check_answer(answer)
    result = prepare_word(answer) == prepare_word(original_text)

    if result
      set_review_interval
    else
      increment!(:incorrect_answers)
      set_review_interval if incorrect_answers == 3

      result
    end
  end

  def set_review_interval
    if incorrect_answers == 3
      update_attributes(review_date: Time.now + 12.hours,
                        correct_answers: 0, incorrect_answers: 0)
    else
      increment!(:correct_answers)

      update_attributes(review_date: Time.now + interval(correct_answers))
    end
  end

  def interval(attempts)

    case attempts
      when 1 then 12.hours
      when 2 then 3.days
      when 3 then 1.week
      when 4 then 2.weeks
      else 1.month
    end

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
    self.review_date = Time.now
  end

  def self.find_or_create_deck(deck_name, user)
    deck = user.decks.find_by(name: deck_name)

    deck || user.decks.create(name: deck_name)
  end
end
