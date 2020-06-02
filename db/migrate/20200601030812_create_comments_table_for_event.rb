class CreateCommentsTableForEvent < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.integer :user_id, null: false
      t.integer :event_id, null: false
      t.text :text, null: false
      t.integer :reply_to
      t.timestamps
    end
  end
end
