class CreateSubareas < ActiveRecord::Migration
  def change
    create_table :subareas do |t|
      t.string :name
      t.integer :area_id
      t.string :tabelog_code

      t.timestamps
    end

    add_index :subareas, :name
    add_index :subareas, :tabelog_code
  end
end
