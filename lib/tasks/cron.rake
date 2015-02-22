namespace :cron do
  desc 'scrape Tabelog in batches'
  task :add_restaurants => :environment do
    TabelogScraper.run_batch
  end

  task :fill_details => :environment do
  	TabelogScraper.batch_fill_restaurant_details
  end

  task :reverse_fill_details => :environment do
    TabelogScraper.reversed_batch_fill_restaurant_details
  end

  task :random_fill_details => :environment do
    TabelogScraper.random_batch_fill_restaurant_details
  end

  task :add_images => :environment do
  	TabelogScraper.batch_add_tabelog_images
  end
end
