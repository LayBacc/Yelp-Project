class CreateRestaurantImages < ActiveRecord::Migration
  def change
    create_table :restaurant_images do |t|
      t.string :url
      t.integer :restaurant_id, index: true

      t.timestamps
    end
  end
end
