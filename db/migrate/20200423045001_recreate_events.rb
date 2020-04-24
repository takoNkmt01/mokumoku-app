class RecreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :event_name, null: false
      t.string :event_content, null: false
      t.string :overview, null: false
      t.integer :event_capacity, null: false
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false
      t.string :necessities, default: "必要なものはありません!"
      t.timestamps
      t.integer :user_id
    end
  end
end
