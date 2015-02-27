namespace :data do
  desc 'store front_image_url in restaurants table'
  task :set_front_image => :environment do
    Restaurant.where(front_image_url: nil).find_each(batch_size: 1000) do |r|
      image = r.images.first
      r.update(front_image_url: image.url) if image.present?
    end
  end
end
