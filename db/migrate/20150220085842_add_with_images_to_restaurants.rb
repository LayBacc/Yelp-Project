class AddWithImagesToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :with_images, :boolean
  end
end
