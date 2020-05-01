class DeleteDefaultValueFromMaps < ActiveRecord::Migration[5.2]
  def change
    drop_table :maps
  end
end
