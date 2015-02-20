class RemoveWithDetailsFlagsFromRestaurants < ActiveRecord::Migration
  def change
  	remove_column :restaurants, :with_details
  	remove_column :restaurants, :with_images
  end
end
