class AddCategoryIdToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :category_id, :integer, index: true
  end
end
