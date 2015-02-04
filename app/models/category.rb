class Category < ActiveRecord::Base
  has_many :restaurant_categories, dependent: :destroy
  has_many :restaurants, through: :restaurant_categories

  def tabelog_path
  	"rstLst/#{name}/"
  end
end
