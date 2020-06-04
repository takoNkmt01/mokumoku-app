class AddIndexToTagAndUser < ActiveRecord::Migration[5.2]
  def up
    add_index :users, :email, unique: true
    add_index :tags, :name, unique: true
  end

  def down
    remove_index :users, :email
    remove_index :tags, :name
  end
end
