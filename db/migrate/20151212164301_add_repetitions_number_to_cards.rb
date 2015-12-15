class AddRepetitionsNumberToCards < ActiveRecord::Migration
  def change
    add_column :cards, :repetitions_number, :integer, default: 0
  end
end
