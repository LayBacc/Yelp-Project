class AddWithDetailsFlagToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :with_details, :boolean, default: false
  end
end
