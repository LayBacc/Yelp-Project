class AddCityToAreaAndSubarea < ActiveRecord::Migration
  def change
    add_column :areas, :city, :string
    add_column :subareas, :city, :string
  end
end
