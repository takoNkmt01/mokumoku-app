class RenameSomeColumnsInEvents < ActiveRecord::Migration[5.2]
  def up
    rename_column :events, :event_name, :title
    rename_column :events, :event_content, :content
    rename_column :events, :event_capacity, :capacity
  end

  def down
    rename_column :events, :title, :event_name
    rename_column :events, :content, :event_content
    rename_column :events, :capacity, :event_capacity
  end
end
