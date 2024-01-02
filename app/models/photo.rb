class Photo < ApplicationRecord
  belongs_to :user
  mount_uploaders :images, ImageUploader

  with_options presence: true do
    validates :password
    validates :images
    validates :encrypt_password
    validates :salt
  end

  def self.password_matches?(password)
    if password
      where("password = ?", password)
    else
      none
    end
  end

  def generate_encrypt_password_and_salt
    self.encrypt_password = SecureRandom.hex(16)
    self.salt = SecureRandom.hex(8)
  end

  # 画像を暗号化してJSONに保存する
  def encrypt_and_save_image_to_json(image_path, json_path)
    binding.pry
    encryptor = ImageEncryptor.new(image_path, self.encrypt_password, self.salt)
    encryptor.process_and_save_image_to_json(json_path)
  end

  # 復号化
  def decrypt_and_decode_to_image(encrypted_data, encrypted_password, salt)
    encrypted_json_data = JSON.parse(File.read(encrypted_data))
    decryptor = ImageEncryptor.new(encrypted_json_data, encrypted_password, salt)
    decrypted_data = decryptor.decrypt_image(encrypted_json_data)
  end
end
