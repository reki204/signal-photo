require 'rails_helper'
require 'tempfile'
require 'pry-rails'
require 'pry-byebug'
require 'base64'

RSpec.describe ImageEncryptor, type: :model do
  let(:image_path) do
    Rack::Test::UploadedFile.new(
      Rails.root.join("spec/fixtures/spec_image.jpg")
    )
  end
  let(:password) { 'test_password' }
  let(:salt) { 'test_salt' }

  describe '#initialize' do
    it 'initializes ImageEncryptor with the correct parameters' do
      encryptor = ImageEncryptor.new(image_path, password, salt)
      expect(encryptor.instance_variable_get(:@image_path)).to eq(image_path)
      expect(encryptor.instance_variable_get(:@password)).to eq(password)
      expect(encryptor.instance_variable_get(:@salt)).to eq(salt)
    end
  end

  # describe '#process_and_save_image_to_json' do
  #   it 'reads the image file' do
  #     encryptor = ImageEncryptor.new(image_path, password, salt)
  #     expect(encryptor).to receive(:read_image)
  #     allow(encryptor).to receive(:read_image).and_return('dummy image data')
  #     expect(encryptor.send(:read_image)).to eq('dummy image data')
  #   end

  #   it 'converts the image data to base64' do
  #     encryptor = ImageEncryptor.new(image_path, password, salt)
  #     expect(encryptor).to receive(:convert_to_base64)
  #     allow(encryptor).to receive(:convert_to_base64).and_return('dummy_base64_data')
  #     expect(encryptor.send(:convert_to_base64, 'dummy image data')).to eq('dummy_base64_data')
  #   end

  #   it 'encrypts the image data' do
  #     encryptor = ImageEncryptor.new(image_path, password, salt)
  #     expect(encryptor).to receive(:encrypt_image)
  #     allow(encryptor).to receive(:encrypt_image).and_return(iv: 'dummy_iv', encrypted: 'dummy_encrypted_data')
  #     expect(encryptor.send(:encrypt_image, 'dummy_base64_data')).to eq({ iv: 'dummy_iv', encrypted: 'dummy_encrypted_data' })
  #   end

  #   it 'saves the encrypted data to JSON' do
  #     encryptor = ImageEncryptor.new(image_path, password, salt)
  #     allow(encryptor).to receive(:save_to_json)
  #     encryptor.process_and_save_image_to_json('dummy_output.json')
  #     expect(encryptor).to have_received(:save_to_json).with('dummy_output.json', any_args)
  #   end
  # end

  # encrypt_image
  # describe '#encrypt_image' do
  #   it 'returns the expected hash with Base64-encoded iv and encrypted data' do
  #     # テストデータ
  #     test_data = 'dummy_data'
  #     iv = 'dummy_iv'
  #     encrypted_data = 'dummy_encrypted_data'

  #     # ImageEncryptor インスタンスを作成
  #     encryptor = ImageEncryptor.new(image_path, password, salt)

  #     # OpenSSL::Cipher オブジェクトをモック化
  #     cipher_double = instance_double(OpenSSL::Cipher)
  #     allow(OpenSSL::Cipher).to receive(:new).and_return(cipher_double)

  #     # cipher ダブルの設定
  #     allow(cipher_double).to receive(:padding=)
  #     allow(cipher_double).to receive(:encrypt)
  #     allow(cipher_double).to receive(:key=)
  #     allow(cipher_double).to receive(:random_iv).and_return(iv)
  #     allow(cipher_double).to receive(:update).with(test_data).and_return(encrypted_data)
  #     allow(cipher_double).to receive(:final)

  #     # Base64 ダブルを使用してエンコード結果をモック
  #     iv_base64 = Base64.strict_encode64(iv)
  #     encrypted_data_base64 = Base64.strict_encode64(encrypted_data)
  #     allow(Base64).to receive(:strict_encode64).with(iv).and_return(iv_base64)
  #     allow(Base64).to receive(:strict_encode64).with(encrypted_data).and_return(encrypted_data_base64)

  #     # 期待される結果
  #     expected_result = { iv: iv_base64, encrypted: encrypted_data_base64 }

  #     # テスト対象メソッドを呼び出す
  #     # result = encryptor.encrypt_image(test_data)

  #     # 期待される結果と一致することを検証
  #     expect(result).to eq(expected_result)
  #   end
  # end

  describe '#process_and_save_image_to_json' do
    it 'reads the image file, converts to base64, encrypts, and saves to JSON' do
      # モックをセットアップ
      encryptor = ImageEncryptor.new(image_path, password, salt)

      # ファイルデータ
      file_data = File.read(image_path.path)
      # puts "file_data: #{file_data}"
      allow(encryptor).to receive(:read_image).and_return(file_data)

      # Base64 エンコードされた画像データ
      base64_data = Base64.strict_encode64(file_data)
      allow(encryptor).to receive(:convert_to_base64).with(file_data).and_return(base64_data)

      # テスト対象メソッドを呼び出す
      # encryptor.process_and_save_image_to_json('dummy_output.json')
      # expect(encryptor).to have_received(:encrypt_image).with(base64_data)

      # 暗号化結果
      encrypted_data = Base64.strict_encode64('dummy_encrypted_data')
      iv = Base64.strict_encode64('dummy_iv')
      allow(encryptor).to receive(:encrypt_image).with(base64_data).and_return(iv: iv, encrypted: encrypted_data)

      # テスト対象メソッドを呼び出す
      result = encryptor.process_and_save_image_to_json('dummy_output.json')
      # result = encryptor.encrypt_image(base64_data)
      puts "resultの中身: #{result}"
      # 期待されるメソッドの戻り値を検証
      expect(result).to eq({ iv: iv, encrypted: encrypted_data })
      expect(encryptor).to have_receive(:encrypt_image).with(base64_data)
      # expect(result).to eq({ iv: iv, encrypted: encrypted_data })

      # allow(encryptor).to receive(:save_to_json)

      # encryptor.process_and_save_image_to_json('dummy_output.json')

      # expect(encryptor).to have_received(:read_image).once
      # expect(encryptor).to have_received(:convert_to_base64).with('dummy image data').once
      # expect(encryptor).to have_received(:encrypt_image).with('dummy_base64_data').once
      # expect(encryptor).to have_received(:save_to_json).with('dummy_output.json', iv: 'dummy_iv', encrypted: 'dummy_encrypted_data').once
    end
  end

  describe 'decrypt_image' do
    it 'correctly decrypts the image data' do
      test_text = '画像イメージデータ'
      iv = Base64.strict_encode64(OpenSSL::Cipher.new('AES-256-CBC').random_iv)
      # iv = Base64.strict_encode64(OpenSSL::Random.random_bytes(16))
      # iv = Base64.strict_encode64('dummy_iv')
      encrypted_image_data = Base64.strict_encode64(test_text)
      encrypted_data = {
        'iv' => iv,
        'encrypted' => encrypted_image_data
      }
      encryptor = ImageEncryptor.new(image_path, password, salt)
      puts "encryptorの中身: #{encryptor}"
      decrypted_image_data = encryptor.decrypt_image(encrypted_data)
      expect(decrypted_image_data.force_encoding('UTF-8')).to eq(test_text)
      # expect(decrypted_image_data).to eq(test_text)
    end
  end
end
