module Api
  module V1
    class PhotosController < ApplicationController
      before_action :set_search_password, only: :index
      rescue_from StandardError, with: :handle_internal_error

      def index
        decrypted_images = Photo
          .non_deleted
          .password_matches(@search_password)
          .recent
          .newer_than(7.days.ago)
          .filter_map(&:decrypted_image_json)

        render json: { status: :success, message: 'success', data: decrypted_images }
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
          FileUtils.mkdir_p(target_dir)

          # 画像を暗号化してJSONに保存
          json_path = "#{target_dir}/encrypted_#{photo.id}.json"
          photo.encrypt_and_save_image_to_json(uploaded_file_path, json_path)

          render json: { status: :success, message: 'success' }
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

      def set_search_password
        @search_password = request.headers['X-Search-Password']
      end

      def photo_params
        params.require(:photo).permit(:password, images: [])
      end

      def handle_internal_error(error)
        Rails.logger.error "Error in PhotosController #{error.class}: #{error.message}"
        render json: { status: :internal_server_error, message: "Error: #{error.message}" }
      end
    end
  end
end
