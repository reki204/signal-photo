require 'rails_helper'
require 'tempfile'
require 'pry-rails'
require 'pry-byebug'

RSpec.describe ImageEncryptor, type: :model do
  let(:image_path) { 
    Rack::Test::UploadedFile.new(
      Rails.root.join("spec/fixtures/spec_image.jpg")
    )
  }
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

  describe '#process_and_save_image_to_json' do
    it 'reads the image file' do
      encryptor = ImageEncryptor.new(image_path, password, salt)
      expect(encryptor).to receive(:read_image)
      allow(encryptor).to receive(:read_image).and_return('dummy image data')
      expect(encryptor.send(:read_image)).to eq('dummy image data')
    end

    it 'converts the image data to base64' do
      encryptor = ImageEncryptor.new(image_path, password, salt)
      expect(encryptor).to receive(:convert_to_base64)
      allow(encryptor).to receive(:convert_to_base64).and_return('dummy_base64_data')
      expect(encryptor.send(:convert_to_base64, 'dummy image data')).to eq('dummy_base64_data')
    end

    it 'encrypts the image data' do
      encryptor = ImageEncryptor.new(image_path, password, salt)
      expect(encryptor).to receive(:encrypt_image)
      allow(encryptor).to receive(:encrypt_image).and_return(iv: 'dummy_iv', encrypted: 'dummy_encrypted_data')
      expect(encryptor.send(:encrypt_image, 'dummy_base64_data')).to eq({ iv: 'dummy_iv', encrypted: 'dummy_encrypted_data' })
    end

    it 'saves the encrypted data to JSON' do
      encryptor = ImageEncryptor.new(image_path, password, salt)
      allow(encryptor).to receive(:save_to_json)
      encryptor.process_and_save_image_to_json('dummy_output.json')
      expect(encryptor).to have_received(:save_to_json).with('dummy_output.json', any_args)
    end
  end
end
