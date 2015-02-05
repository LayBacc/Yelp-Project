require 'nokogiri'
require 'open-uri'

class TabelogScraper 
  ROOT_URL = 'http://tabelog.com/'
  USER_AGENT = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36'
  PROXY_LIST = "#{Rails.root}/lib/assets/proxy_ips.txt"
  @@proxies = Array.new

  class << self
    def fetch_page(path)
      @@proxies = load_proxies if @@proxies.empty?
      Nokogiri::HTML(open(ROOT_URL + path, proxy: "http://#{select_proxy}/", 'User-Agent' => USER_AGENT, 'Referer' => 'http://www.tabelog.com/'))
    rescue OpenURI::HTTPError
      fetch_page(page)
    rescue Errno
      Nokogiri::HTML(open(ROOT_URL + path, 'User-Agent' => USER_AGENT, 'Referer' => 'http://www.tabelog.com/'))
    end

    def select_proxy
      @@proxies[rand(@@proxies.count)]
    end

    def proxies
      @@proxies
    end

    # load proxies into memory
    def load_proxies
      proxies = Array.new
      File.open(PROXY_LIST, 'r').each_line do |line|
        proxies << line.strip
      end
      proxies
    end

    # to determine whether we are blocked by Tabelog
    def test_yelp
      @@proxies = load_proxies if @@proxies.empty?
      puts select_proxy
      Nokogiri::HTML(open('http://yelp.com', proxy: "http://#{select_proxy}/", 'User-Agent' => USER_AGENT, 'Referer' => 'http://www.yelp.com/'))
    rescue OpenURI::HTTPError
      test_yelp
    end

    def test_dummy
      Nokogiri::HTML(open("http://bit.ly/gearshare"))
    end

    def add_areas
      page = fetch_page('tokyo/')
      page.css('#contents-narrowarea ul.list-area li.area').each do |area|
        tabelog_code = area.css('a')[0]['href'].split('/').last
        Area.create(name: area.text, tabelog_code: tabelog_code) unless Area.exists?(name: area.text)
      end
    end

    def add_subareas
      Area.all.each do |area|
        page = fetch_page(area.tabelog_path)
        subareas = page.css('#contents-narrowarea ul.list-area li.area a')
        subareas.each do |subarea|
          tabelog_code = subarea['href'].split('/').last
          Subarea.create(name: subarea.text, tabelog_code: tabelog_code, area_id: area.id) unless Subarea.exists?(name: subarea.text)
        end
      end
    end

    def add_categories
      page = fetch_page('tokyo/')
      page.css('#contents-situation ul.list-genre li.genre a').each do |category|
      	name = category['href'].split('/').last
      	Category.create(name: name, name_jp: category.text) unless Category.exists?(name: name)
      end
    end

    def num_pages(subarea, category)
      page = fetch_page("#{subarea.tabelog_path}#{category.tabelog_path}")
      page.css('.main-title span.count')[0].text.to_i / 20 + 1
    end

    def bulk_add_restaurants
  	  Subarea.all.each do |subarea|
  	  	Category.all.each do |category|
  	  	  (1..num_pages(subarea, category)).each do |page_num|
  	  		   add_page_restaurants(subarea, category, page_num)
  	  	  end
  	  	end
  	  end
    end

    def add_page_restaurants(subarea, category, page_num=1)
      path = page_num == 1 ? "#{subarea.tabelog_path}#{category.tabelog_path}" : "#{subarea.tabelog_path}#{category.tabelog_path}#{page_num}/"
      page = fetch_page(path)
      
      page.css('ul.rstlist-info li.rstlst-group').each do |listing|
      	title_node = listing.css('.rstname a')[0]
      	tabelog_url = title_node['href']

      	restaurant = Restaurant.find_or_create_by(name: title_node.text, tabelog_url: tabelog_url)
      	restaurant.city = 'Tokyo'
      	restaurant.area = subarea.area_id
      	restaurant.subarea = subarea.id

      	RestaurantCategory.create(restaurant_id: restaurant.id, category_id: category.id) unless restaurant.categories.exists?(category)

        restaurant.save
      end
    end

    # TODO - on the restaurant page
    def fill_restaurant_detail
      
    end
  end
end