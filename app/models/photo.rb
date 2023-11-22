class Photo < ApplicationRecord
  belongs_to :user
  mount_uploader :image, ImageUploader

  with_options presence: true do
    validates :password
    validates :image
  end

  def self.match_password(password)
    if password
      where("password = ?", password)
    else
      none
    end
  end
end
