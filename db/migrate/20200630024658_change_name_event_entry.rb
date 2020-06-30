class ChangeNameEventEntry < ActiveRecord::Migration[5.2]
  def change
    rename_table :event_entries, :member_entries
  end
end
