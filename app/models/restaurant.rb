class Restaurant < ActiveRecord::Base
  DISTANCE_RADIUS = 0.005

  has_many :restaurant_categories, dependent: :destroy
  has_many :categories, through: :restaurant_categories

  has_many :matches
  # has_many :opponents

  enum area: Area.all.pluck(:name)
  enum subarea: Subarea.all.pluck(:name)

  scope :near, ->(lat, lng) do
  	where('latitude BETWEEN ? AND ?', lat - DISTANCE_RADIUS, lat + DISTANCE_RADIUS)
  	.where('longitude BETWEEN ? AND ?', lng - DISTANCE_RADIUS, lng + DISTANCE_RADIUS)
  end
  scope :in_category, ->(cat_id) do
    joins('INNER JOIN restaurant_categories ON restaurants.id = restaurant_categories.restaurant_id')
    .where('restaurant_categories.category_id = ?', cat_id)
  end
  scope :any_two, -> { order('RANDOM()').limit(2) }
  scope :pick_two, ->(lat, lng, cat_id) { in_category(cat_id).near(lat, lng).any_two }
end