class CreateEvent < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :event_name, null: false
      t.string :event_content, null: false
      t.datetime :start_time, null: false
      t.integer :user_id, null: false
      t.timestamps
    end
  end
end
