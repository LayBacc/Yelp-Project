class YelpScraper < Scraper
  ROOT_URL = 'http://www.yelp.com/'

  class << self
  	def add_sf_neighborhoods
  	  path = ROOT_URL + yelp_encode("search?find_desc=restaurants&find_loc=San Francisco, CA&ns=1#")
  	  page = fetch_page(path, false)

  	  neighborhoods = page.css('.place-more .place')
  	  neighborhoods.each do |n|
  	  	name = n.css('span')[0].text
  	  	value = n.css('input')[0]['value']

  	  	puts name
  	  	puts value
  	  end
  	end

  	# STRUCTURE: by neighbourhood, by price range
  	# this ensures that no single batch exceeds the 1000 restaurants results limit
    def results_page(location, page_num)
      path = ROOT_URL + yelp_encode("search?find_desc=restaurants&find_loc=#{location}&ns=1#start=#{(page_num-1) * 10}")
      page = fetch_page(path, false)
      
      restaurants = page.css('.biz-listing-large')
      restaurants.each do |r|
      	image = r.css('img')
      	title = r.css('.search-result-title .biz-name')[0].text
      	num_reviews = r.css('.review-count')[0].text.strip
      	price_range = r.css('.price-range')
      	categories = r.css('.category-str.list')
      	neighborhood = r.css('.neighborhood-str-list')
      	address = r.css('address')[0].text
      	phone = r.css('.biz-phone')

      	puts title
      	puts num_reviews
      	puts price_range
      	puts categories
      	puts neighborhood
      	puts address
      	puts phone
      	puts image
      end
    end

    def yelp_encode(str)
      str.gsub(/\s/, '+').gsub(/\,/, '%2C')      
    end
  end
end
