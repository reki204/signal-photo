FactoryBot.define do
  factory :photo do
    user
    password { 'password' }
    body { 'photo_body' }
    image {
      Rack::Test::UploadedFile.new(
        Rails.root.join('spec', 'fixtures', 'spec_image.jpg')
      )
    }
  end
end
