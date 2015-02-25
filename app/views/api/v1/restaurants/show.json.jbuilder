json.merge! @restaurant.attributes
json.subarea @restaurant.subarea.to_s
json.display_address @restaurant.display_address
json.positive_rate @restaurant.positive_rate
json.stats @restaurant.top_three_stats
if params[:images] != false
  json.images @restaurant.images.first(5) do |image|
  	json.url image.url
  end
end
json.categories @restaurant.categories do |category|
  json.id category.id
  json.name category.name
  json.name_jp category.name_jp
end
