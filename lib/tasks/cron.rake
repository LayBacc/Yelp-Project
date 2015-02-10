namespace :cron do
  desc 'scrape Tabelog in batches'
  task :add_restaurants => :environment do
    TabelogScraper.run_batch
  end

  task :fill_details => :environment do
  	TabelogScraper.batch_fill_restaurant_details
  end
end
