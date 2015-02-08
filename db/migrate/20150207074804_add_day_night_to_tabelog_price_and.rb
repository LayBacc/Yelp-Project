class AddDayNightToTabelogPriceAnd < ActiveRecord::Migration
  def change
  	add_column :tabelog_prices, :price_type, :integer
  	remove_column :tabelog_prices, :selected
  	add_column :tabelog_prices, :selected, :integer 
  end
end
