class ChangeColumnNameNotification < ActiveRecord::Migration[5.2]
  def up
    rename_column :notifications, :room_id, :entry_id
    add_index :notifications, :entry_id
  end

  def down
    rename_column :notifications, :entry_id, :room_id
    add_index :notifications, :room_id
  end
end
