class Match < ActiveRecord::Base
  belongs_to :first, class_name: 'Restaurant'
  belongs_to :second, class_name: 'Restaurant'
  belongs_to :category

  scope :by_restaurant_id, ->(restaurant_id) { where('first_id = ? OR second_id = ?', restaurant_id, restaurant_id) }
  scope :by_category_id, ->(category_id) { where(category_id: category_id) }

  class << self
    def matched?(first_id, second_id, user_id)
      where(user_id: user_id).where('(first_id = ? AND second_id = ?) OR (first_id = ? AND second_id = ?)', first_id, second_id, second_id, first_id).any?
    end
  end
end
