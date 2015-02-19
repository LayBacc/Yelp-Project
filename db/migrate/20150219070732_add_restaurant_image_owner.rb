class AddRestaurantImageOwner < ActiveRecord::Migration
  def change
  	add_column :restaurant_images, :user_id, :integer, index: true
  end
end
