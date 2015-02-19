class AddDescriptionToRestaurantImages < ActiveRecord::Migration
  def change
    add_column :restaurant_images, :description, :text
  end
end
