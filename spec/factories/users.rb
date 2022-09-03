FactoryBot.define do
  factory :user do
    username { 'username' }
    sequence(:email) { |n| "email#{n}@example.com" }
    password { 'password' }
  end
end
