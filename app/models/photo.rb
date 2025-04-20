class Photo < ApplicationRecord
  belongs_to :user
  mount_uploaders :images, ImageUploader

  with_options presence: true do
    validates :password, :images, :encrypt_password, :salt
  end

  scope :non_deleted, -> { where(deleted_at: nil) }
  scope :password_matches, ->(pwd) { pwd.present? ? where(password: pwd) : all }
  scope :recent, -> { order(created_at: :desc) }
  scope :newer_than, ->(time) { where('created_at >= ?', time) }

  # 暗号化パスワードとソルトを生成
  def generate_encrypt_password_and_salt
    self.encrypt_password = SecureRandom.hex(16)
    self.salt = SecureRandom.hex(8)
  end

  # 画像を暗号化してJSONに保存する
  def encrypt_and_store_images
    images.each do |img|
      source_path = img.current_path
      json_path = storage_dir.join("encrypted_#{id}.json").to_s
      ImageEncryptor.new(encrypt_password, salt)
        .encrypt_and_save!(source_path, json_path)
    end
  end

  # 復号化、画像バイナリのBase64を返す
  def decrypted_image_json
    json_path = storage_dir.join("encrypted_#{id}.json").to_s
    return unless File.exist?(json_path)

    binary = ImageEncryptor.new(encrypt_password, salt).decrypt!(json_path)
    { image_data: Base64.strict_encode64(binary) }
  rescue StandardError => e
    Rails.logger.error "Photo#decrypted_image_json #{e.message}"
    nil
  end

  private

  def storage_dir
    Pathname.new(Rails.root).join('public', password)
  end
end
