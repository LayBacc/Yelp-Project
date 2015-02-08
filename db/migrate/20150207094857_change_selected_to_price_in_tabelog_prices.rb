class ChangeSelectedToPriceInTabelogPrices < ActiveRecord::Migration
  def change
  	remove_column :tabelog_prices, :selected
  	add_column :tabelog_prices, :price, :integer
  end
end
