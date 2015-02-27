class AddUrbanspoonCountsAndLinksToSubareas < ActiveRecord::Migration
  def change
    add_column :subareas, :urbanspoon_count, :integer
    add_column :subareas, :urbanspoon_link, :string
    add_column :areas, :urbanspoon_count, :integer
    add_column :areas, :urbanspoon_link, :string
  end
end
