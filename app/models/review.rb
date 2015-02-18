class Review < ActiveRecord::Base
  belongs_to :restaurant
  enum rating: { negative: -1, neutral: 0, positive: 1 }
end
