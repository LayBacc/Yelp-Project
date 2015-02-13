class Restaurant < ActiveRecord::Base
  DISTANCE_RADIUS = 0.005

  has_many :restaurant_categories, dependent: :destroy
  has_many :categories, through: :restaurant_categories
  has_many :matches
  has_many :images, class_name: 'RestaurantImage', dependent: :destroy

  enum area: Area.all.pluck(:name)
  enum subarea: Subarea.all.pluck(:name)
  enum price_bucket: ['～￥999', '￥1,000～￥1,999', '￥2,000～￥2,999', '￥3,000～￥3,999', '￥4,000～￥4,999', '￥5,000～￥5,999', '￥6,000～￥7,999', '￥8,000～￥9,999', '￥10,000～￥14,999', '￥15,000～￥19,999', '￥20,000～￥29,999', '￥30,000～'] 

  scope :near, ->(lat, lng) do
  	where('latitude BETWEEN ? AND ?', lat - DISTANCE_RADIUS, lat + DISTANCE_RADIUS)
  	.where('longitude BETWEEN ? AND ?', lng - DISTANCE_RADIUS, lng + DISTANCE_RADIUS)
  end
  scope :with_category_id, ->(cat_id) do
    joins('INNER JOIN restaurant_categories ON restaurants.id = restaurant_categories.restaurant_id')
    .where('restaurant_categories.category_id = ?', cat_id)
  end
  scope :in_category, ->(category) do
    joins('INNER JOIN restaurant_categories ON restaurants.id = restaurant_categories.restaurant_id')
    .joins('INNER JOIN categories ON restaurant_categories.category_id = categories.id')
    .where('categories.name = ?', category)
  end

  scope :random, ->(num) { order('RANDOM()').limit(num) }
  scope :match_latlng, ->(lat, lng, cat_id, num) { with_category_id(cat_id).near(lat, lng).random(num) }
  scope :in_subarea, ->(subarea_name) { where(subarea: Subarea.id_by_name(subarea_name)) }

  # TODO - this is n + 1 query
  def front_image
    image = images.first
    image.present? ? image.url : 'http://placehold.it/150x150'
  end

  class << self
    def query(params)
      if params[:category_id].present?
        scoped = with_category_id(params[:category_id])
      else
        scoped = in_category(params[:category])
      end

      if params[:latitude].present? && params[:longitude].present?
        scoped = scoped.near(params[:latitude], params[:longitude]) 
      else
        scoped = scoped.in_subarea(params[:subarea])
      end
      scoped
    end
  end
end