require 'nokogiri'
require 'open-uri'

class Scraper
  USER_AGENT = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.16 Safari/537.36' #'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36'

  FILE_PATH = "#{Rails.root}/lib/assets/"
  PROXY_LIST = "#{FILE_PATH}proxy_ips.txt"
  BAD_PROXY_LIST = "#{FILE_PATH}bad_proxies.txt"
  PROGRESS_LOG = "#{Rails.root}/log/scraping.log"

  @@proxies = Array.new

  class << self
  	def proxies
      @@proxies
    end

    def fetch_page(path, with_root=true)
      @@proxies = load_proxies if @@proxies.empty?
      proxy = select_proxy
      path = ROOT_URL + path if with_root
      Nokogiri::HTML(open(path, proxy: "http://#{proxy}/", 'User-Agent' => USER_AGENT, 'Referer' => 'http://www.yelp.com/'))
      # Nokogiri::HTML(open(path, proxy: "http://#{proxy}/", 'User-Agent' => USER_AGENT, 'Referer' => 'http://www.tabelog.com/'))
    rescue OpenURI::HTTPError, Errno::ETIMEDOUT => error
      puts "fetch_page error, url: #{path}"
      puts error.message
      return
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

    # TODO - tentative method to get images from google
    def add_google_image(restaurant)
      @@proxies = load_proxies if @@proxies.empty?
      proxy = select_proxy

      query = URI::encode("#{restaurant.name}#{restaurant.subarea}")
      url = "https://www.google.co.jp/search?q=#{query}&tbm=isch"
      page = Nokogiri::HTML(open(url, proxy: "http://#{proxy}/", 'User-Agent' => USER_AGENT))

      puts page.css('img')
    end
  end
end