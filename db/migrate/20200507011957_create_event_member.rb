class CreateEventMember < ActiveRecord::Migration[5.2]
  def change
    create_table :event_members do |t|
      t.integer :event_id, null: false
      t.integer :user_id, null: false
      t.boolean :organizer, default: false
      t.timestamps
    end

    add_index :event_members, :event_id
    add_index :event_members, :user_id
    add_index :event_members, [:event_id, :user_id], unique: true
  end
end
