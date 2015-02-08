class TabelogPrice < ActiveRecord::Base
  enum price: ['～￥999', '￥1,000～￥1,999', '￥2,000～￥2,999', '￥3,000～￥3,999', '￥4,000～￥4,999', '￥5,000～￥5,999', '￥6,000～￥7,999', '￥8,000～￥9,999', '￥10,000～￥14,999', '￥15,000～￥19,999', '￥20,000～￥29,999', '￥30,000～'] 
  enum price_type: [:lunch, :dinner]

  def increment_vote(bucket_name)
  	index = TabelogPrice.prices[bucket_name]

  	# TODO - update ratings string 
  end

  # tie breaker: the lower index
  def most_vote
  	
  end
end
