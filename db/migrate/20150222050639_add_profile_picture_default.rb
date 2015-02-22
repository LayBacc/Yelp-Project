class AddProfilePictureDefault < ActiveRecord::Migration
  def change
  	change_column :users, :profile_image_url, :string, default: 'http://placehold.it/150x150'
  end
end
