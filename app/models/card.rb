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

  scope :condition,         -> { where('review_date <= ?', Time.zone.now) }
  scope :random_for_review, -> { condition.offset(rand(condition.count)) }

  INTERVALS = [12.hours, 3.days, 1.week, 2.weeks]

  def check_answer(answer)
    result = prepare_word(answer) == prepare_word(original_text)

    if result
      set_review_interval_correct_answers
    elsif number_of_typos(answer) <= 2
      :typo_in_word
    else
      set_review_interval_wrong_answers ? :wrong_answers_streak : :wrong_answer
    end
  end

  def set_review_interval_correct_answers
    interval = INTERVALS[correct_answers] || 1.month

    update_attributes(review_date: Time.zone.now + interval,
                      correct_answers: correct_answers + 1, incorrect_answers: 0)

    :correct_answer
  end

  def set_review_interval_wrong_answers
    increment!(:incorrect_answers)

    if incorrect_answers == 3
      update_attributes(review_date: Time.zone.now + 12.hours,
                        correct_answers: 0, incorrect_answers: 0)
    end
  end

  def self.create_card_in_deck(user, params)
    deck = find_or_create_deck(params[:deck_name], user)

    deck.cards.build(params)
  end

  def self.notify_user_for_review_pending_cards
    Card.where('review_date <= ?', Time.zone.now).each do |card|
      CardsMailer.pending_cards_notification(card.deck.user).deliver_now
    end
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

  def number_of_typos(answer)
    DamerauLevenshtein.distance(original_text, answer, 0)
  end
end
