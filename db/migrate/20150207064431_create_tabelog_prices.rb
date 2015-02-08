class CreateTabelogPrices < ActiveRecord::Migration
  def change
    create_table :tabelog_prices do |t|
      t.string :ratings
      t.string :selected

      t.timestamps
    end
  end
end
