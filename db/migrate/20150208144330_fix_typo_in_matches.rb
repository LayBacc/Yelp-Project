class FixTypoInMatches < ActiveRecord::Migration
  def change
  	remove_column :matches, :winnter
  	add_column :matches, :winner, :integer
  end
end
