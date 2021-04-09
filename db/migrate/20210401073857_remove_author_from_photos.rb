class RemoveAuthorFromPhotos < ActiveRecord::Migration[6.1]
  def change
    remove_column :photos, :image, :string
  end
end
