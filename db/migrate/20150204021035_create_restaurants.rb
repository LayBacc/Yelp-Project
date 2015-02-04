class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name, null: false
      t.text :description
      t.string :telephone
      t.string :hours
      t.string :street_address
      t.text :direction
      t.string :holiday
      t.string :lunch_price
      t.string :dinner_price
      t.string :tabelog_url
      t.string :city
      t.integer :area
      t.integer :subarea
      t.float :latitude
      t.float :longitude

      t.timestamps
    end

    add_index :restaurants, :city
    add_index :restaurants, :area
    add_index :restaurants, :subarea
    add_index :restaurants, :latitude
    add_index :restaurants, :longitude
  end
end
