class UrbanspoonScraper < Scraper
  ROOT_URL = 'http://www.urbanspoon.com/'

  class << self
  	def add_sf_neighborhoods
      east_bay_path = 'g/6/303/SF-Bay/East-Bay-restaurants'
      page = fetch_page(ROOT_URL + east_bay_path, false)

      restaurants = page.css('li[data-ga-action="filter-Neighborhoods"] a[data-ga-action="neighborhood"]').map{ |node| [node['title'].gsub(/Restaurants in /, ''), node['href'], node.css('small')[0].text] }
      puts restaurants
  	end
  end
end
