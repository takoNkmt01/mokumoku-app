class AddCapacityToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :event_capacity, :integer, null: false
  end
end
