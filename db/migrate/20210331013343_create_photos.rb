class CreatePhotos < ActiveRecord::Migration[6.1]
  def change
    create_table :photos do |t|
      t.text :body
      t.string :password
      t.string :image
      t.integer :user_id

      t.timestamps
    end
  end
end
