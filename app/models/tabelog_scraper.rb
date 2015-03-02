class TabelogScraper < Scraper
  ROOT_URL = 'http://tabelog.com/'
  
  SUBAREA_BATCH_SIZE = 5
  CATEGORY_BATCH_SIZE = 42

  class << self
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

    def batch_add_restaurants(offset_s=0, limit_s=1, offset_c=0, limit_c=10, page_offset=0, page_limit=nil)
      Subarea.offset(offset_s).limit(limit_s).each do |subarea|
        Category.offset(offset_c).limit(limit_c).each do |category|
          end_page = page_limit.present? ? page_limit : num_pages(subarea, category)
          (page_offset+1..end_page).each do |page_num|
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
      Restaurant.where(lunch_price: nil).where(telephone: nil).where(street_address: nil).first(100).each do |restaurant|
        fill_restaurant_detail(restaurant)
      end
    end

    def reversed_batch_fill_restaurant_details
      Restaurant.where(lunch_price: nil).where(telephone: nil).where(street_address: nil).last(100).each do |restaurant|
        fill_restaurant_detail(restaurant)
      end
    end

    def random_batch_fill_restaurant_details
      Restaurant.where(lunch_price: nil).where(telephone: nil).where(street_address: nil).random(100).each do |restaurant|
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
      return unless page.present?
      
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

      dinner_price, lunch_price = scrape_prices(page)
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
        lunch_price: lunch_price,
        dinner_price: dinner_price,
        purposes: purposes
      })
    end

    def batch_add_tabelog_images
      # TODO - this query can't scale, bringing all entries to memory, and would be slow...
      res_ids = RestaurantImage.pluck(:restaurant_id).uniq
      Restaurant.where.not(id: res_ids).random(100).each do |restaurant|
        add_tabelog_images(restaurant)
      end
    end

    def add_tabelog_images(restaurant)
      page = fetch_page(restaurant.tabelog_url, false)
      return unless page.present?

      images = page.css('.mainphoto-box img.mainphoto-image').present? ? page.css('.mainphoto-box img.mainphoto-image').map { |node| node['src'] } : Array.new

      images = (page.css('.photoimg .photo-box img').present? ? page.css('.photoimg .photo-box img').map { |node| node['src'] } : Array.new) if images.empty?

      images.each do |url|
        restaurant.images.create(url: url)
      end
    end

    def fill_categories(restaurant)
      page = fetch_page(restaurant.tabelog_url, false)
      return unless page.present?

      categories = page.css('.genre-info .parent a')
      categories = categories.present? ? categories.map{ |c| c.text.gsub(/（その他）/, '') } : Array.new

      categories.each do |name|
        category = Category.where(name: name).first
        RestaurantCategory.create(restaurant_id: restaurant.id, category_id: category.id) if category.present? && !RestaurantCategory.exists?(restaurant_id: restaurant.id, category_id: category.id)
      end
      puts categories
    end
  end
end
