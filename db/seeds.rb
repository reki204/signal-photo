# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# image_path = Rails.root.join('db', 'fixtures', 'mike.jpg')
# image_blob = ActiveStorage::Blob.create_and_upload!!(
#   io: File.open(image_path),
#   filename: 'mike.jpg',
#   content_type: 'image/jpeg'
# )
20.times do
  Photo.create!(
    password: 'mike',
    user_id: 1,
    # image: File.open(
    #   Rails.root.join('app/assets/images/mike.jpg')
    # )
    images: [File.open("#{Rails.root}/db/fixtures/mike.jpg")]
  )
end
