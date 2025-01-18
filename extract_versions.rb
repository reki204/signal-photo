# Gemfile からバージョンを抽出して README に追加するスクリプト

require 'bundler'

# Gemfile のパス
gemfile_path = 'Gemfile'

# Gemfile から Ruby と Rails のバージョンを抽出
ruby_version = nil
rails_version = nil

File.readlines(gemfile_path).each do |line|
  if line.match(/^ruby\s+['"](.*)['"]$/)
    ruby_version = $1
  elsif line.match(/^gem ['"]rails['"]\s*,\s*['"](.*)['"]/)
    rails_version = $1
  end
end

# バージョン情報を出力
if ruby_version && rails_version
  puts "Ruby Version: #{ruby_version}"
  puts "Rails Version: #{rails_version}"
else
  puts "必要なバージョン情報が Gemfile に見つかりませんでした。"
end
