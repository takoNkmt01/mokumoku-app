class ChangeMapsToAccessMaps < ActiveRecord::Migration[5.2]
  def change
    rename_table :maps, :access_maps
  end
end
