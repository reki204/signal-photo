source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

gem 'rails', '~> 6.1.3', '>= 6.1.3.1'
gem 'puma'
gem 'sass-rails'
gem 'webpacker'
gem 'turbolinks'
gem 'jbuilder'
gem 'bcrypt'
gem 'bootsnap', require: false

group :development, :test do
  gem 'sqlite3'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'database_cleaner'
end

group :development do
  gem 'web-console'
  gem 'rack-mini-profiler'
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

group :production do
  gem 'pg'
end