class AddCorrectAnswersToCard < ActiveRecord::Migration
  def change
    add_column :cards, :correct_answers, :integer, default: 0
  end
end
