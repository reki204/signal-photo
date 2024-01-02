class AddEncryptPasswordAndSaltToPhotos < ActiveRecord::Migration[7.1]
  def change
    add_column :photos, :encrypt_password, :string
    add_column :photos, :salt, :string
  end
end
