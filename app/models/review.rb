class Review < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :user
  enum rating: { negative: -1, neutral: 0, positive: 1 }

  scope :with_user, ->() { joins('INNER JOIN users ON users.id = reviews.user_id').select('reviews.*, users.first_name AS first_name, users.profile_image_url AS profile_image_url') }
end
