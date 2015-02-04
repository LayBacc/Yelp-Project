class CreateRestaurantCategories < ActiveRecord::Migration
  def change
    create_table :restaurant_categories do |t|
      t.integer :restaurant_id
      t.integer :category_id

      t.timestamps
    end

    add_index :restaurant_categories, :restaurant_id
    add_index :restaurant_categories, :category_id
  end
end
