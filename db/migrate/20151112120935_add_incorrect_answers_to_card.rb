class AddIncorrectAnswersToCard < ActiveRecord::Migration
  def change
    add_column :cards, :incorrect_answers, :integer, default: 0
  end
end
