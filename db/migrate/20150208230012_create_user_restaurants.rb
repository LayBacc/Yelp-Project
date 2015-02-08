class CreateUserRestaurants < ActiveRecord::Migration
  def change
    create_table :user_restaurants do |t|
      t.integer :user_id, index: true
      t.integer :restaurant_id, index: true
      t.integer :context, index: true

      t.timestamps
    end
  end
end
