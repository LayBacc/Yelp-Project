namespace :cron do
  desc 'scrape Tabelog in batches'
  task :add_restaurants => :environment do
    TabelogScraper.run_batch
  end

  task :fill_details => :environment do
  	TabelogScraper.batch_fill_restaurant_details
  end

  task :add_images => :environment do
  	TabelogScraper.batch_add_tabelog_images
  end
end
