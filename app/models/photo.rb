class Photo < ApplicationRecord
  belongs_to :user
  mount_uploader :image, ImageUploader
  

  with_options presence: true do
    validates :password
    validates :image
  end
end
