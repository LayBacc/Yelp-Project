class Match < ActiveRecord::Base
  belongs_to :first, class_name: 'Restaurant'
  belongs_to :second, class_name: 'Restaurant'

  class << self
    def start_match
      loop do
      	# get two random restaurants
      	first, second = Restaurant.pick_two
      	match = Match.new()
      break unless matched?
      match
    end

    def matched?(first, second)
      # check both sides
    end

    def new_opponent_for(restaurant)
      # loop until we've found an opponent the user hasn't seen before
      # if exhausted, move both restaurants
    end
  end
end
