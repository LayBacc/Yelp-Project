require 'nokogiri'
require 'open-uri'

class TabelogScraper 
  ROOT_URL = 'http://tabelog.com/'
  USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36'
  FILE_PATH = "#{Rails.root}/lib/assets/"
  PROXY_LIST = "#{FILE_PATH}proxy_ips.txt"
  BAD_PROXY_LIST = "#{FILE_PATH}bad_proxies.txt"
  PROGRESS_LOG = "#{FILE_PATH}bad_proxies.txt"
  @@proxies = Array.new

  class << self
    def proxies
      @@proxies
    end

    def fetch_page(path)
      @@proxies = load_proxies if @@proxies.empty?
      proxy = select_proxy
      Nokogiri::HTML(open(ROOT_URL + path, proxy: "http://#{proxy}/", 'User-Agent' => USER_AGENT, 'Referer' => 'http://www.tabelog.com/'))
    rescue OpenURI::HTTPError, Errno::ETIMEDOUT, Errno::ECONNREFUSED, Net::ReadTimeout
      log_bad_proxy(proxy)
      fetch_page(path)  # try again
    end

    def select_proxy
      @@proxies[rand(@@proxies.count)]
    end

    def log_bad_proxy(proxy)
      File.open(BAD_PROXY_LIST, 'a') do |file|
        file.write("#{proxy}\n")
      end
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
      proxy = select_proxy
      Nokogiri::HTML(open('http://yelp.com', proxy: "http://#{proxy}/", 'User-Agent' => USER_AGENT, 'Referer' => 'http://www.yelp.com/', read_timeout: 5))
    rescue OpenURI::HTTPError, Errno::ETIMEDOUT, Errno::ECONNREFUSED, Net::ReadTimeout
      log_bad_proxy(proxy)
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

    def log_progress(subarea, category, page_num)
      File.open(PROGRESS_LOG, 'a') do |file|
        file.write("#{subarea.id}-#{subarea.name}\t#{category.id}-#{category.name}\tp.#{page_num}\n")
      end
    end

    def bulk_add_restaurants(offset_s=0, limit_s=1, offset_c=0, limit_c=10, page_limit=nil)
      Subarea.offset(offset_s).each do |subarea|
        Category.offset(offset_c).each do |category|
          end_page = page_limit.present? ? page_limit : num_pages(subarea, category)
          (1..num_pages(subarea, category)).each do |page_num|
            log_progress(subarea, category, page_num)
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
