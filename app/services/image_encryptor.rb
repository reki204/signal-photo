require 'openssl'
require 'base64'
require 'json'
require 'fileutils'

class ImageEncryptor
  def initialize(password, salt)
    @password = password
    @salt = salt
  end

  # 画像を暗号化してJSONに保存
  def process_and_save_image_to_json(image_path, json_path)
    image_data = File.binread(image_path)
    encrypted_data = encrypt_image(image_data)
    save_to_json(json_path, encrypted_data)
  end

  # 暗号化されたデータを復号化
  def decrypt_image(encrypted_data)
    iv = Base64.strict_decode64(encrypted_data['iv'])
    encrypted_body = Base64.strict_decode64(encrypted_data['encrypted'])

    cipher = OpenSSL::Cipher.new('AES-256-CBC')
    cipher.decrypt

    key_iv = OpenSSL::PKCS5.pbkdf2_hmac_sha1(@password, @salt, 100_000, cipher.key_len + cipher.iv_len)
    cipher.key = key_iv[0, cipher.key_len]
    cipher.iv = iv
    
    begin
      cipher.update(encrypted_body) + cipher.final
    rescue OpenSSL::Cipher::CipherError => e
      raise "Decryption error: #{e.message}. Possible incorrect password or corrupted data."
    end
  end

  private

  # 画像データを暗号化
  def encrypt_image(data)
    cipher = OpenSSL::Cipher.new('AES-256-CBC')
    cipher.encrypt

    key_iv = OpenSSL::PKCS5.pbkdf2_hmac_sha1(@password, @salt, 100_000, cipher.key_len + cipher.iv_len)
    cipher.key = key_iv[0, cipher.key_len]

    # 初期化ベクトル (IV) を生成
    iv = cipher.random_iv
    cipher.iv = iv

    encrypted_data = cipher.update(data) + cipher.final

    {
      iv: Base64.strict_encode64(iv),
      encrypted: Base64.strict_encode64(encrypted_data)
    }
  end

  # 暗号化データをJSONとして保存
  def save_to_json(json_path, encrypted_data)
    # ディレクトリが存在することを確認
    FileUtils.mkdir_p(File.dirname(json_path))
    
    # JSONとして保存
    File.write(json_path, encrypted_data.to_json)
  end
end
