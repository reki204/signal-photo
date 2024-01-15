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
    encrypted_data = encrypt_image(image_data)
    save_to_json(json_path, encrypted_data)
  end

  def decrypt_image(encrypted_data)
    iv = Base64.strict_decode64(encrypted_data['iv'])
    encrypted_body = Base64.strict_decode64(encrypted_data['encrypted'])

    cipher = OpenSSL::Cipher.new('AES-256-CBC')
    cipher.decrypt

    key_iv = OpenSSL::PKCS5.pbkdf2_hmac_sha1(@password, @salt, 100000, cipher.key_len + cipher.iv_len)
    cipher.key = key_iv[0, cipher.key_len]
    cipher.iv = iv
    decrypted_data = cipher.update(encrypted_body) + cipher.final

    decrypted_data
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

    key_iv = OpenSSL::PKCS5.pbkdf2_hmac_sha1(@password, @salt, 100000, cipher.key_len + cipher.iv_len)
    iv = key_iv[cipher.key_len, cipher.iv_len]
    cipher.key = key_iv[0, cipher.key_len]
    cipher.iv = iv

    encrypted_data = cipher.update(data) + cipher.final

    {
      iv: Base64.strict_encode64(iv),
      encrypted: Base64.strict_encode64(encrypted_data)
    }
  end

  def save_to_json(json_path, encrypted_data)
    FileUtils.mkdir_p(File.dirname(json_path))
    File.write(json_path, encrypted_data.to_json)
  end
end
