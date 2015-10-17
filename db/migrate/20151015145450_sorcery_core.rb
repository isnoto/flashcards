class SorceryCore < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :crypted_password, :string
    add_column :users, :salt, :string

    add_index :users, :salt, unique: true
    remove_column :users, :password
  end

end