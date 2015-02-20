class Review < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :user
  enum rating: { negative: -1, neutral: 0, positive: 1 }

  # scope :with_user, ->() { joins('INNER JOIN users ON users.id = reviews.user_id').select('reviews.*, users.name AS user_name') }
end
