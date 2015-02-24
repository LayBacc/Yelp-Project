class AddDefaultValuesToMatchStats < ActiveRecord::Migration
  def change
  	change_column :match_stats, :num_matches, :integer, default: 0
  	change_column :match_stats, :num_wins, :integer, default: 0
  	change_column :match_stats, :num_draws, :integer, default: 0
  end
end
