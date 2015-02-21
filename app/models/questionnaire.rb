class Questionnaire < ActiveRecord::Base
  belongs_to :restaurant

  # TODO - map topic to options
  # TODO - move these to constants
  enum topic: ['Ambience', 'Price Range', 'Attire', 'Good for Groups', 'Good for Kids', 'Good For', 'Noise Level']
  enum price: ['～￥999', '￥1,000～￥1,999', '￥2,000～￥2,999', '￥3,000～￥3,999', '￥4,000～￥4,999', '￥5,000～￥5,999', '￥6,000～￥7,999', '￥8,000～￥9,999', '￥10,000～￥14,999', '￥15,000～￥19,999', '￥20,000～￥29,999', '￥30,000～']
  enum attire: ['Casual', 'Dressy', 'Formal']
  enum noise_level: ['Quiet', 'Average', 'Loud', 'Very Loud']
  enum ambience: [:divey, :hipster, :casual, :touristy, :trendy, :intimate, :romantic, :classy, :upscale]	
end
