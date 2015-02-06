namespace :cron do
  desc 'scrape Tabelog in batches'
  task :add_restaurants => :environment do
    TabelogScraper.run_batch
  end
end
