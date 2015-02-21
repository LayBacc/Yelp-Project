class ChangeQuestionnaireModel < ActiveRecord::Migration
  def change
  	remove_column :questionnaires, :price
  	remove_column :questionnaires, :purpose
  	add_column :questionnaires, :topic, :integer, index: true
  	add_column :questionnaires, :value, :integer, index: true
  end
end
