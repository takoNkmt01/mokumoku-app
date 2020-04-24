class AddSomeColumnToEvents < ActiveRecord::Migration[5.2]
  def up
    execute 'DELETE FROM events;'
    add_column :events, :overview, :string, null: false
    add_column :events, :necessities, :string, default: '必要なものは特にありません!'
  end

  def down
    remove_column :events, :overview, :string, null: false
    remove_column :events, :necessities, :string, default: '必要なものは特にありません!'
  end
end
