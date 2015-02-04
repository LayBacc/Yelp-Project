class AddIndexToRestaurantTabelogUrl < ActiveRecord::Migration
  def change
  	add_index :restaurants, :tabelog_url
  end
end
