class Area < ActiveRecord::Base
  has_many :subareas

  def tabelog_path
  	"tokyo/#{tabelog_code}/"
  end
end
