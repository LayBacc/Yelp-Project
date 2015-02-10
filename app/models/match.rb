class Match < ActiveRecord::Base
  belongs_to :first, class_name: 'Restaurant'
  belongs_to :second, class_name: 'Restaurant'

  class << self
    # def start_match(lat, lng, cat, user)
    #   loop do
    #   	first_r, second_r = Restaurant.match(lat, lng, cat, 2)
    #   	match = Match.new(first_id: first_r.id, second_id: second_r.id, user_id: user_id)
    #   	break unless matched?(first_r.id, second_r.id, user.id)
    #   end
    #   match
    # end

    # # inefficient, deprecate this
    # def opponent_for(restaurant, category)
    #   loop do
    #   	opponent = Restaurant.match(restaurant.latitude, restaurant.longitude, category, 1)
    #   	break unless opponent.id == restaurant.id
    #   end
    #   opponent
    # end

    def matched?(first_id, second_id, user_id)
      where(user_id: user_id).where('(first_id = ? AND second_id = ?) OR (first_id = ? AND second_id = ?)', first_id, second_id, second_id, first_id).any?
    end
  end
end
