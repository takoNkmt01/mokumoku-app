class AddNullFalseToOverviewInEvents < ActiveRecord::Migration[5.2]
  def up
    change_column :events, :overview, :text, null: false
  end

  def down
    change_column :events, :overview, :text, null: true
  end
end
