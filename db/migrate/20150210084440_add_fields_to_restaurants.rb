class AddFieldsToRestaurants < ActiveRecord::Migration
  def change
  	add_column :restaurants, :seats, :string
  	add_column :restaurants, :parking, :string
  	add_column :restaurants, :facilities, :string
  	add_column :restaurants, :home_page, :string
  	add_column :restaurants, :opening_date, :string
  	add_column :restaurants, :tabelog_group_id, :string
  	add_column :restaurants, :lunch_prices, :string
  	add_column :restaurants, :dinner_prices, :string
  	add_column :restaurants, :purposes, :string
  end
end
