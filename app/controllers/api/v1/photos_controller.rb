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
        photo.generate_encrypt_password_and_salt

        if photo.save
          # 画像の暗号化と保存
          photo.encrypt_and_store_images
          render json: { status: :success, message: 'success' }
        else
          render json: {
            status: :unprocessable_entity,
            message: 'Validation error',
            errors: photo.errors
          }
        end
      end

      private

      def set_search_password
        @search_password = request.headers['X-Search-Password']
      end

      def photo_params
        params.require(:photo).permit(:password, encrypted_image: [])
      end

      def handle_internal_error(error)
        Rails.logger.error "Error in PhotosController #{error.class}: #{error.message}"
        render json: { status: :internal_server_error, message: "Error: #{error.message}" }
      end
    end
  end
end
