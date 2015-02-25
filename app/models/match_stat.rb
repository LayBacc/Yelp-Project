class MatchStat < ActiveRecord::Base
  belongs_to :category
  belongs_to :restaurant

  scope :fetch, ->(restaurant_ids, category_id) { where(restaurant_id: restaurant_ids).where(category_id: category_id) }

  def update_rates
  	update(win_rate: num_wins/num_matches, draw_rate: num_draws/num_matches)
  end

  def increment_draw
  	update(num_draws: num_draws + 1)
  end

  def increment_win
  	update(num_wins: num_wins + 1)
  end

  def increment_total
  	update(num_matches: num_matches + 1)
  end

  class << self
    def add_match(match)
      stat1 = MatchStat.find_or_create_by(restaurant_id: match.first_id, category_id: match.category_id)
      stat2 = MatchStat.find_or_create_by(restaurant_id: match.second_id, category_id: match.category_id)
      if match.winner == 1
      	stat1.increment_win
      elsif match.winner == 2
      	stat2.increment_win
      else
      	stat1.increment_draw
      	stat2.increment_draw
      end

      stat1.increment_total
      stat2.increment_total
      stat1.update_rates
      stat2.update_rates
    end
  end
end
