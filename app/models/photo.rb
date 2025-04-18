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
    password.present? ? where(password: password) : all
  end

  # 暗号化パスワードとソルトを生成
  def generate_encrypt_password_and_salt
    self.encrypt_password = SecureRandom.hex(16)
    self.salt = SecureRandom.hex(8)
  end

  # 画像を暗号化してJSONに保存する
  def encrypt_and_save_image_to_json(image_path, json_path)
    raise "Image file not found at path: #{image_path}" unless File.exist?(image_path)

    encryptor = ImageEncryptor.new(encrypt_password, salt)
    encryptor.process_and_save_image_to_json(image_path, json_path)
  end

  # 復号化して画像バイナリを返す
  def decrypt_and_decode_to_image(encrypted_json_path, encrypted_password, salt)
    raise "Encrypted file not found at path: #{encrypted_json_path}" unless File.exist?(encrypted_json_path)

    encrypted_json_data = JSON.parse(File.read(encrypted_json_path))
    decryptor = ImageEncryptor.new(encrypted_password, salt)
    decryptor.decrypt_image(encrypted_json_data)
  end
end
