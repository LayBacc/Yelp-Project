require 'nokogiri'
require 'open-uri'

class TabelogScraper 
  ROOT_URL = 'http://tabelog.com/'
  USER_AGENT = 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)' #'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36'

  FILE_PATH = "#{Rails.root}/lib/assets/"
  PROXY_LIST = "#{FILE_PATH}proxy_ips.txt"
  BAD_PROXY_LIST = "#{FILE_PATH}bad_proxies.txt"
  PROGRESS_LOG = "#{Rails.root}/log/scraping.log"

  SUBAREA_BATCH_SIZE = 5
  CATEGORY_BATCH_SIZE = 42

  @@proxies = Array.new

  class << self
    def proxies
      @@proxies
    end

    def run_batch
      batch_add_restaurants(next_subarea_offset, SUBAREA_BATCH_SIZE, 0, CATEGORY_BATCH_SIZE, 0)
    end

    def fetch_page(path, with_root=true)
      @@proxies = load_proxies if @@proxies.empty?
      proxy = select_proxy
      path = ROOT_URL + path if with_root
      Nokogiri::HTML(open(path, proxy: "http://#{proxy}/", 'User-Agent' => USER_AGENT, 'Referer' => 'http://www.tabelog.com/'))
    rescue OpenURI::HTTPError, Errno::ECONNREFUSED, Net::ReadTimeout
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

    # TODO - tentative method to get images from google
    def add_google_image(restaurant)
      @@proxies = load_proxies if @@proxies.empty?
      proxy = select_proxy

      query = URI::encode("#{restaurant.name}#{restaurant.subarea}")
      url = "https://www.google.co.jp/search?q=#{query}&tbm=isch"
      page = Nokogiri::HTML(open(url, proxy: "http://#{proxy}/", 'User-Agent' => USER_AGENT))

      puts page.css('img')
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

    def batch_add_restaurants(offset_s=0, limit_s=1, offset_c=0, limit_c=10, page_offset=0, page_limit=nil)
      Subarea.offset(offset_s).limit(limit_s).each do |subarea|
        Category.offset(offset_c).limit(limit_c).each do |category|
          end_page = page_limit.present? ? page_limit : num_pages(subarea, category)
          (page_offset+1..end_page).each do |page_num|
            log_progress(subarea, category, page_num)
  	  		  add_page_restaurants(subarea, category, page_num)
  	  	  end
  	  	end
  	  end
    end

    def next_subarea_offset
      tag = RestaurantCategory.last
      tag.present? ? Restaurant.subareas[tag.restaurant.subarea] : 0
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

    def batch_fill_restaurant_details
      Restaurant.where('with_details = false OR with_details IS NULL').limit(100).each do |restaurant|
        fill_restaurant_detail(restaurant)
      end
    end

    def strip_table_cell(text, with_space=false)
      with_space ? text.gsub(/\<\/*td\>|\<\/*p\>/, '') : text.gsub(/\<\/*td\>|\<\/*p\>|\s/, '')
    end

    # aggergate all bucket and save
    # a tabelog_price model that has buckets as attributes
    def scrape_prices(page)
      dinner = page.css('.chart-left li p.rate-price').present? ? page.css('.chart-left li p.rate-price').map { |node| node.next_element.text.gsub(/\[|\]/, '') }.join('-') : nil
      lunch = page.css('.chart-right li p.rate-price').present? ? page.css('.chart-right li p.rate-price').map { |node| node.next_element.text.gsub(/\[|\]/, '') }.join('-') : nil
      [dinner, lunch]
    end

    def scrape_purposes(page)
      page.css('li p.rate-icon').present? ? page.css('li p.rate-icon').map { |node| node.next_element.css('strong').text }.join('-') : nil
    end

    def fill_restaurant_detail(restaurant)
      page = fetch_page("#{restaurant.tabelog_url}dtlratings/", false)
      
      telephone = page.css('#tel_info strong')[0].present? ? page.css('#tel_info strong')[0].text : nil
      street_address = page.css('tr.address span a').present? ? page.css('tr.address span a').map { |node| node.text }.join('') : nil
      direction = page.at('th:contains("交通手段")').present? ? strip_table_cell(page.at('th:contains("交通手段")').next_element.text) : nil
      hours = page.at('th:contains("営業時間")').present? ? strip_table_cell(page.at('th:contains("営業時間")').next_element.text, true).strip : nil
      holiday = page.at('th:contains("定休日")').present? ? strip_table_cell(page.at('th:contains("定休日")').next_element.text) : nil

      seats = page.at('th:contains("席数")').present? ? page.at('th:contains("席数")').next_element.css('p').text.gsub(/\<\/*strong\>/, '').strip : nil
      parking = page.at('th:contains("駐車場")').present? ? page.at('th:contains("駐車場")').next_element.css('p').text.gsub(/\<\/*strong\>/, '').strip : nil
      facilities = page.at('th:contains("空間・設備")').present? ? page.at('th:contains("空間・設備")').next_element.css('p').text.strip : nil

      home_page = page.at('th:contains("ホームページ")').present? ? page.at('th:contains("ホームページ")').next_element.css('a').text.strip : nil
      opening_date = page.at('th:contains("オープン日")').present? ? strip_table_cell(page.at('th:contains("オープン日")').next_element.text) : nil
      tabelog_group_id = page.at('th:contains("関連店舗情報")').present? ? page.at('th:contains("関連店舗情報")').next_element.css('a')[0]['href'].split("/").last : nil

      latitude, longitude = page.css('.rst-map img').present? ? page.css('.rst-map img')[0]['src'].match(/center=[0-9]*\.*[0-9]*,[0-9]*\.*[0-9]*/).to_s.gsub(/center=/, '').split(',') : [nil, nil]

      dinner_prices, lunch_prices = scrape_prices(page)
      purposes = scrape_purposes(page)

      restaurant.update({
        telephone: telephone,
        street_address: street_address,
        direction: direction,
        hours: hours,
        holiday: holiday,
        seats: seats,
        parking: parking,
        facilities: facilities,
        home_page: home_page,
        opening_date: opening_date,
        tabelog_group_id: tabelog_group_id,
        latitude: latitude.to_f,
        longitude: longitude.to_f,
        lunch_prices: lunch_prices,
        dinner_prices: dinner_prices,
        purposes: purposes,
        with_details: true
      })

      # add_tabelog_images(restaurant)
    end

    def add_tabelog_images(restaurant)
      page = fetch_page("#{restaurant.tabelog_url}", false)
      images = page.css('.mainphoto-box img.mainphoto-image').present? ? page.css('.mainphoto-box img.mainphoto-image').map { |node| node['src'] } : Array.new

      images.each do |url|
        restaurant.images.create(url: url)
      end
    end

    # add groups to the restaurant
    def add_groups
      
    end
  end
end
