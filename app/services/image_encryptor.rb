require 'openssl'
require 'base64'
require 'json'
require 'fileutils'

class ImageEncryptor
  ALGORITHM = 'AES-256-CBC'.freeze
  ITERATIONS = 100_000

  def initialize(password, salt)
    @password = password
    @salt = salt
  end

  # 画像ファイルを読み込んで暗号化し、JSONに保存
  # @param image_path 画像のパス
  # @param json_path 出力するJSONのパス
  def encrypt_and_save!(image_path, json_path)
    raise Errno::ENOENT, "Image not found: #{image_path}" unless File.exist?(image_path)

    image_data = File.binread(image_path)
    encrypted = encrypt(data)
    write_json!(json_path, encrypted)
  end

  # JSON ファイルを読み込んで復号し、バイナリを返す
  # @param json_path 暗号化 JSON のパス
  # @return 復号済バイナリ
  def decrypt!(json_path)
    raise Errno::ENOENT, "Encrypted file not found: #{json_path}" unless File.exist?(json_path)

    payload = JSON.parse(File.read(json_path))
    decrypt(payload)
  rescue JSON::ParserError => e
    raise "Invalid JSON format: #{e.message}"
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

  # 暗号化
  def encrypt(data)
    cipher = OpenSSL::Cipher.new(ALGORITHM).encrypt
    key, iv = derive_key_and_iv(cipher)

    cipher.key = key
    cipher.iv  = iv
    encrypted = cipher.update(data) + cipher.final

    {
      'iv' => Base64.strict_encode64(iv),
      'encrypted' => Base64.strict_encode64(encrypted)
    }
  end

  # 復号
  def decrypt(payload)
    cipher = OpenSSL::Cipher.new(ALGORITHM).decrypt
    key, _iv = derive_key_and_iv(cipher)

    iv_body = Base64.strict_decode64(payload['iv'])
    encrypted_body    = Base64.strict_decode64(payload['encrypted'])

    cipher.key = key
    cipher.iv  = iv_body

    cipher.update(encrypted_body) + cipher.final
  rescue OpenSSL::Cipher::CipherError => e
    raise "Decryption error: #{e.message}"
  end

  # PBKDF2 でキー＋IV を導出
  def derive_key_and_iv(cipher)
    key_iv = OpenSSL::PKCS5.
      pbkdf2_hmac_sha1(@password, @salt, ITERATIONS, cipher.key_len + cipher.iv_len)

    key = key_iv[0, cipher.key_len]
    iv  = key_iv[cipher.key_len, cipher.iv_len]
    [key, iv]
  end

  # JSONの書き出し
  def write_json!(path, data)
    FileUtils.mkdir_p(File.dirname(path))
    File.write(path, JSON.generate(data))
  end
end
