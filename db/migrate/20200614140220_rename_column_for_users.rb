class RenameColumnForUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :username, :full_name
  end
end
