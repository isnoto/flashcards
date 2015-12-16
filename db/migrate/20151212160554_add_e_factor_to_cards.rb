class AddEFactorToCards < ActiveRecord::Migration
  def change
    add_column :cards, :e_factor, :float, default: 2.5
  end
end
