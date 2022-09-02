FactoryBot.define do
  factory :photo do
    user
    password { 'password' }
    body { 'photo_body' }
    image { 'image' }
  end
end
