class RemoveTabelogPrices < ActiveRecord::Migration
  def change
  	drop_table :tabelog_prices
  end
end
