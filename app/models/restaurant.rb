class Restaurant < ActiveRecord::Base
  has_many :restaurant_categories, dependent: :destroy
  has_many :categories, through: :restaurant_categories
end
