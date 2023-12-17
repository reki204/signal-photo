class Photo < ApplicationRecord
  belongs_to :user
  mount_uploaders :images, ImageUploader

  with_options presence: true do
    validates :password
    validates :images
  end

  def self.password_matches?(password)
    if password
      where("password = ?", password)
    else
      none
    end
  end
end
