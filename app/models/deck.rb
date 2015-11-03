class Deck < ActiveRecord::Base
  belongs_to :user
  has_many :cards

  validates :name, presence: true

  def current?
    current_deck = User.find_by(id: self.user_id).current_deck_id

    self.id == current_deck
  end
end
