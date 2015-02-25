class Review < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :user
  enum rating: { negative: -1, neutral: 0, positive: 1 }

  scope :with_user, ->() { joins('INNER JOIN users ON users.id = reviews.user_id').select('reviews.*, users.first_name AS first_name, users.profile_image_url AS profile_image_url') }
  scope :positive_rate, ->() { select('CAST((SELECT COUNT(*) FROM reviews WHERE rating = 1) AS float) / CAST((SELECT COUNT(*) FROM reviews) AS float) * 100 AS percentage').first }
end
