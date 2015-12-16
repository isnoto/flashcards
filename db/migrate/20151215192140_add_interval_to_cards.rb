class AddIntervalToCards < ActiveRecord::Migration
  def change
    add_column :cards, :interval, :integer, default: 0
  end
end
