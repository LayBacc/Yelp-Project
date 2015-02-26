class AddFrontImageUrlToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :front_image_url, :string
  end
end
