class UrbanspoonScraper < Scraper
  ROOT_URL = 'http://www.urbanspoon.com/'

  class << self
  	def add_sf_neighborhoods
      east_bay_path = 'g/6/303/SF-Bay/East-Bay-restaurants'
      page = fetch_page(ROOT_URL + east_bay_path, false)

      neighborhoods = page.css('li[data-ga-action="filter-Neighborhoods"] li[data-ga-catg="Filter"] a')

      curr_area = nil
      neighborhoods.each do |n|
      	if n['class'] =~ /neighborhood_group/
          curr_area = Area.create(name: n['title'], city: 'San Francisco', urbanspoon_count: n.css('small')[0].text.gsub(/\(|\)/, ''), urbanspoon_link: n['href'])
        else
          Subarea.create(name: n['title'], city: 'San Francisco', urbanspoon_count: n.css('small')[0].text.gsub(/\(|\)/, ''), urbanspoon_link: n['href'], area_id: curr_area.id)
        end
      end
  	end
  end
end
