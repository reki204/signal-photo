# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# ユーザーの作成（存在しない場合のみ）
user = User.find_or_create_by!(id: 1) do |u|
  u.email = 'test@example.com'
  u.password = 'password'
  u.password_confirmation = 'password'
end

# 画像のパスを設定
image_path = Rails.root.join('db/fixtures/mike.jpg')

# 画像データの作成（暗号化処理あり）
3.times do
  photo = Photo.new(
    password: 'mike',
    user: user,
    images: [File.open(image_path)]
  )

  # 暗号化用のパスワードとソルトを生成
  photo.generate_encrypt_password_and_salt

  if photo.save
    # 画像を暗号化してJSONに保存
    encrypted_json_path = Rails.root.join("public/#{photo.password}/encrypted_#{photo.id}.json")
    photo.encrypt_and_save_image_to_json(image_path, encrypted_json_path)
    puts "Photo #{photo.id} created successfully!"
  else
    puts "Failed to create Photo: #{photo.errors.full_messages}"
  end
end
