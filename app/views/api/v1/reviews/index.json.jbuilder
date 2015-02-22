json.reviews @reviews do |review|
  json.merge! review.attributes
  json.first_name review.first_name
  json.profile_image_url review.profile_image_url
  json.rating review.rating.to_s
end