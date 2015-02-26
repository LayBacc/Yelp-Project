json.restaurants @restaurants do |restaurant|
  json.merge! restaurant.attributes
  json.front_image_url restaurant.front_image_url
  json.fuck 'fuck'
end
