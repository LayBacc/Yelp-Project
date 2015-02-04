require 'nokogiri'
require 'open-uri'

class TabelogScraper 
  ROOT_URL = "http://tabelog.com/"

  class << self
    def fetch_page(path)
      Nokogiri::HTML(open(ROOT_URL + path))
    end

    def save_areas
      page = fetch_page('tokyo/')
      page.css('#contents-narrowarea ul.list-area li.area').each do |area|
        tabelog_code = area.css('a')[0]['href'].split('/').last
        Area.create(name: area.text, tabelog_code: tabelog_code) if !Area.exists?(name: area.text)
      end
    end

    def save_subareas
      Area.all.each do |area|
        page = fetch_page(area.tabelog_path)
        subareas = page.css('#contents-narrowarea ul.list-area li.area a')
        subareas.each do |subarea|
          tabelog_code = subarea['href'].split('/').last
          Subarea.create(name: subarea.text, tabelog_code: tabelog_code, area_id: area.id) if !Subarea.exists?(name: subarea.text)
        end
	  end
    end
  end
end