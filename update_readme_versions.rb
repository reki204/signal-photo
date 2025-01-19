require 'bundler'

# Gemfile のパス
gemfile_path = 'Gemfile'
readme_path = 'README.md'

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

  readme_content = File.read(readme_path)

  # Version セクションのバージョン情報
  version_info = "Versions\n- Ruby: #{ruby_version}\n- Rails: #{rails_version}\n"

  # バージョン情報がすでに存在する場合は上書き
  if readme_content.include?("Versions")
    readme_content.gsub!(/Versions\n- Ruby: .*\n- Rails: .*\n/, version_info)
  else
    # 存在しない場合はファイルの末尾に追加
    readme_content += "\n#{version_info}"
  end

  File.write(readme_path, readme_content)
else
  puts "必要なバージョン情報が Gemfile に見つかりませんでした。"
end
