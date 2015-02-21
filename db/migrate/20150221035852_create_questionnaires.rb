class CreateQuestionnaires < ActiveRecord::Migration
  def change
    create_table :questionnaires do |t|
      t.integer :restaurant_id, index: true
      t.integer :user_id, index: true
      t.integer :price
      t.integer :purpose

      t.timestamps
    end
  end
end
