class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :first_id, index: true
      t.integer :second_id, index: true
      t.integer :winnter
      t.integer :user_id, index: true

      t.timestamps
    end
  end
end
