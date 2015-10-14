class AddUserIdToCards < ActiveRecord::Migration
  def change
    add_column :cards, :user_id, :integer, null: false
    add_index :cards, :user_id
  end
end
