class Restaurant < ActiveRecord::Base
  DISTANCE_RADIUS = 0.005
  PRICE_DEFAULT = 'No price data available'

  attr_accessor :display_address

  has_many :restaurant_categories, dependent: :destroy
  has_many :categories, through: :restaurant_categories
  has_many :matches
  has_many :images, class_name: 'RestaurantImage', dependent: :destroy
  has_many :reviews
  has_many :questionnaires
  has_many :match_stats

  # enum area: Area.all.pluck(:name)
  # enum subarea: Subarea.all.pluck(:name)
  enum price_bucket: ['～￥999', '￥1,000～￥1,999', '￥2,000～￥2,999', '￥3,000～￥3,999', '￥4,000～￥4,999', '￥5,000～￥5,999', '￥6,000～￥7,999', '￥8,000～￥9,999', '￥10,000～￥14,999', '￥15,000～￥19,999', '￥20,000～￥29,999', '￥30,000～']

  scope :near_latlng, ->(lat, lng) do
    where('latitude BETWEEN ? AND ?', lat.to_f - DISTANCE_RADIUS, lat.to_f + DISTANCE_RADIUS)
    .where('longitude BETWEEN ? AND ?', lng.to_f - DISTANCE_RADIUS, lng.to_f + DISTANCE_RADIUS)
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
  scope :match_latlng, ->(lat, lng, cat_id, num) { with_category_id(cat_id).near_latlng(lat, lng).random(num) }
  scope :in_subarea, ->(subarea_name) { where(subarea: Subarea.id_by_name(subarea_name)) }

  scope :with_default_image, ->() { select("restaurants.*, COALESCE(restaurants.front_image_url, 'http://placehold.it/200x200') AS front_image_url") }
  
  geocoded_by :full_address

  # Used for geocoding
  def full_address
    [street_address, subarea, city].compact.join(', ')
  end

  def fill_display_address
    self.display_address = street_address.present? ? "#{street_address}, #{city}" : "In #{city}, exact location unknown"
  end

  def fill_latlng
    geocode unless latitude.present? && longitude.present?
  end

  def fill_prices
    self.lunch_price = lunch_price || PRICE_DEFAULT
    self.dinner_price = dinner_price || PRICE_DEFAULT
  end

  def fill_missing
    fill_latlng
    fill_display_address
    fill_prices
  end

  def top_three_stats
    match_stats.with_category_names.limit(3)
  end

  def positive_rate
    reviews.any? ? reviews.positive_rate.percentage : 0.0
  end

  class << self
    def query(params)
      if params[:category_id].present?
        scoped = with_category_id(params[:category_id])
      else
        scoped = in_category(params[:category])
      end

      if params[:latitude].present? && params[:longitude].present?
        scoped = scoped.near_latlng(params[:latitude], params[:longitude]) 
      else
        scoped = scoped.in_subarea(params[:subarea])
      end
      scoped
    end
  end

  def lunch_price
    return nil unless lunch_prices.present?
    most_selected_bucket(lunch_prices)
  end

  def dinner_price
    return nil unless lunch_prices.present?
    most_selected_bucket(dinner_prices)    
  end

  def most_selected_bucket(prices)
    prices = prices.split('-').map { |price| price.to_i }
    Restaurant.price_buckets.keys[prices.index(prices.max)]
  end
end
