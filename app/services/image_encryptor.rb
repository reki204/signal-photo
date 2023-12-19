require 'openssl'
require 'base64'
require 'json'

class ImageEncryptor
  def initialize(image_path, password, salt)
    @image_path = image_path
    @password = password
    @salt = salt
  end

  def process_and_save_image_to_json(json_path)
    image_data = read_image
    base64_data = convert_to_base64(image_data)
    encrypted_data = encrypt_image(base64_data)
    save_to_json(json_path, encrypted_data)
  end

  private

  def read_image
    File.read(@image_path)
  rescue StandardError => e
    raise "Error reading image: #{e.message}"
  end

  def convert_to_base64(file)
    Base64.strict_encode64(file)
  rescue StandardError => e
    raise "Error converting to base64: #{e.message}"
  end

  def encrypt_image(data)
    cipher = OpenSSL::Cipher.new('AES-256-CBC')
    cipher.encrypt
    cipher.key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(@password, @salt, 100000, cipher.key_len)
    iv = cipher.random_iv
    encrypted_data = cipher.update(data) + cipher.final

    {
      iv: Base64.strict_encode64(iv),
      encrypted: Base64.strict_encode64(encrypted_data)
    }
  end

  def save_to_json(json_path, encrypted_data)
    File.write(json_path, encrypted_data.to_json)
  end
end
