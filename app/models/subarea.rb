class Subarea < ActiveRecord::Base
  belongs_to :area

  def tabelog_path
  	"#{area.tabelog_path}#{tabelog_code}/"
  end
end
