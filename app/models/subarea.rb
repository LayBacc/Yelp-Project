class Subarea < ActiveRecord::Base
  belongs_to :area

  def tabelog_path
  	"#{area.tabelog_path}#{tabelog_code}/"
  end

  class << self
  	def id_by_name(name)
      s = find_by(name: name)
      s.present? ? s.id : 0
  	end
  end
end
