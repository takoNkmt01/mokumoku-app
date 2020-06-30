class AddColumnToNotification < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :member_entry_id, :integer
    add_index :notifications, :member_entry_id
  end
end
