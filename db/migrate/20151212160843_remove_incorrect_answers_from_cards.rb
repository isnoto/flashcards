class RemoveIncorrectAnswersFromCards < ActiveRecord::Migration
  def change
    remove_column :cards, :incorrect_answers, :string
  end
end
