module Api
  module V1
    class PhotosController < ApplicationController
      def index
        search_password = request.headers['X-Search-Password']
        photos = Photo.where(deleted_at: nil)
                      .password_matches?(search_password)
                      .order(created_at: :desc)

        decrypted_images = photos.filter_map do |photo|
          next if photo.created_at < 7.days.ago

          encrypted_file_path = "public/#{photo.password}/encrypted_#{photo.id}.json"
          next unless File.exist?(encrypted_file_path)

          begin
            image_binary = photo.decrypt_and_decode_to_image(
              encrypted_file_path, 
              photo.encrypt_password, 
              photo.salt
            )

            image_base64 = Base64.strict_encode64(image_binary)

            {
              image_data: image_base64
            }
          rescue => e
            Rails.logger.error "Error decrypting #{e.message}"
            nil
          end
        end

        render json: { status: :ok, message: 'success', data: decrypted_images }
      rescue StandardError => e
        Rails.logger.error "Error in PhotosController#index: #{e.message}"
        render json: { status: :internal_server_error, message: 'Internal Server Error' }
      end

      def create
        photo = Photo.new(photo_params)
        photo.user_id = current_user.id

        # 暗号化のためのパスワードとソルトを生成
        photo.generate_encrypt_password_and_salt

        if photo.save
          # アップロードされたファイルのパスを取得
          uploaded_file_path = photo.images.first.current_path

          # 保存先ディレクトリを作成
          target_dir = "public/#{photo.password}"
          FileUtils.mkdir_p(target_dir) unless Dir.exist?(target_dir)

          # 画像を暗号化してJSONに保存
          json_path = "#{target_dir}/encrypted_#{photo.id}.json"
          photo.encrypt_and_save_image_to_json(uploaded_file_path, json_path)

          render json: { status: :ok, message: 'success' }
        else
          render json: { 
            status: :unprocessable_entity, 
            message: 'Validation error', 
            errors: photo.errors 
          }, status: :unprocessable_entity
        end
      rescue StandardError => e
        Rails.logger.error "Error in PhotosController#create: #{e.message}"
        render json: { status: :internal_server_error, message: "Error: #{e.message}" }
      end

      private
      def photo_params
        params.require(:photo).permit(:password, images: [])
      end
    end
  end
end
