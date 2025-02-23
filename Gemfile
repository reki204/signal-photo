source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

gem 'rails', '~> 8.0'
gem 'puma'
gem 'bcrypt'
gem 'bootsnap', require: false
gem "importmap-rails"

group :development, :test do
  gem 'sqlite3'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'database_cleaner'
  gem 'rails-controller-testing'
end

group :development do
  gem 'web-console'
  gem 'rack-mini-profiler'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'simplecov'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# 画像系
gem 'carrierwave'
gem 'cloudinary'
# 認証
gem 'devise'
gem 'dotenv-rails'

gem 'cssbundling-rails'
gem 'jsbundling-rails'
gem 'tailwindcss-rails'
gem 'turbo-rails'
gem 'rack-cors'

group :production do
  gem 'pg'
end