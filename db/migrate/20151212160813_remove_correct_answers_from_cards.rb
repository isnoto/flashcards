class RemoveCorrectAnswersFromCards < ActiveRecord::Migration
  def change
    remove_column :cards, :correct_answers, :string
  end
end
