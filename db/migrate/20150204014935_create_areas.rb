class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.string :name
      t.string :tabelog_code

      t.timestamps
    end

    add_index :areas, :tabelog_code
  end
end
