class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :user_id, index: true
      t.integer :restaurant_id, index: true
      t.text :body
      t.integer :rating, index: true

      t.timestamps
    end
  end
end
