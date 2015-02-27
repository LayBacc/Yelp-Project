class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.boolean :visited
      t.integer :restaurant_id, index: true
      t.integer :user_id, index: true

      t.timestamps
    end
  end
end
