class ChangeEventMemberToEventEntry < ActiveRecord::Migration[5.2]
  def change
    rename_table :event_members, :event_entries
  end
end
