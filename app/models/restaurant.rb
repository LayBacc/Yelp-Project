class Restaurant < ActiveRecord::Base
  has_many :restaurant_categories, dependent: :destroy
  has_many :categories, through: :restaurant_categories

  enum area: Area.all.pluck(:name)
  enum subarea: Subarea.all.pluck(:name)
end
