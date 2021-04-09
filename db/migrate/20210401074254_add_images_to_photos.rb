class AddImagesToPhotos < ActiveRecord::Migration[6.1]
  def change
    add_column :photos, :images, :json
  end
end
