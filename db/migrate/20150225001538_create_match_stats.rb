class CreateMatchStats < ActiveRecord::Migration
  def change
    create_table :match_stats do |t|
      t.integer :restaurant_id, index: true
      t.integer :category_id, index: true
      t.integer :num_matches, default: 0
      t.integer :num_wins, default: 0
      t.integer :num_draws, default: 0
      t.float :win_rate, index: true
      t.float :draw_rate, index: true

      t.timestamps
    end
    # execute(
    #   'CREATE INDEX match_stats_win_rate_index ON match_stats ((num_wins / num_matches));'
    #   ) 
    # execute(
    #   'CREATE INDEX match_stats_draw_rate_index ON match_stats ((num_draws / num_matches));'
    # ) 
  end
end
