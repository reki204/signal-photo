class Photo < ApplicationRecord
  belongs_to :user
  mount_uploaders :images, ImageUploader
  # before_create :generate_password_and_salt

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

  def generate_password_and_salt
    self.encrypt_password = SecureRandom.hex(16)
    self.salt = SecureRandom.hex(8)
  end

  def encrypt_and_save_image_to_json(image_path, encrypt_password, salt, json_path)
    encryptor = ImageEncryptor.new(image_path, encrypt_password, salt)
    encryptor.process_and_save_image_to_json(json_path)
  end

  # 復号化
  # def decrypt_image
  #   cipher = OpenSSL::Cipher.new('AES-256-CBC')
  #   cipher.decrypt
  #   cipher.key = encryption_key
  #   cipher.iv = encryption_iv

  #   decrypted_data = cipher.update(encrypted_data) + cipher.final
  #   decrypted_data
  # end

end
