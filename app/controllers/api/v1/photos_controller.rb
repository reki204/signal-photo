module Api
  module V1
    class PhotosController < ApplicationController
      before_action :authenticate_user!, except: :index

      def index
        begin
          photos = Photo.where(deleted_at: nil).password_matches?(params[:search]).order(created_at: :desc)
          decrypted_images = photos.map do |photo|
            next if photo.created_at < 7.days.ago

            image_binary = photo.decrypt_and_decode_to_image("public/#{photo.password}/encrypted_#{photo.id}.json", photo.encrypt_password, photo.salt)
            image_base64 = Base64.strict_encode64(image_binary)

            {
              id: photo.id,
              photo: photo,
              image_data: image_base64
            }
          end.compact
          render json: { status: :ok, message: 'success', data: decrypted_images }
        rescue => e
          # 例外が発生した場合は、Railsのログに記録して、500 Internal Server Errorレスポンスを返す
          Rails.logger.error "Error in PhotosController#index: #{e.message}"
          render json: { status: :error, message: 'Internal Server Error' }, status: :internal_server_error
        end
      end

      def create
        photo = Photo.new(photo_params)
        photo.user_id = current_user.id

        uploaded_file_info = photo.images.first
        uploaded_file_info.path

        # 暗号化のためのパスワードとソルトを生成
        photo.generate_encrypt_password_and_salt

        if photo.save
          # 画像を暗号化してJSONに保存する
          photo.encrypt_and_save_image_to_json(uploaded_file_info.path, "public/#{photo.password}/encrypted_#{photo.id}.json")
          render json: { status: :ok, message: 'success', data: photo }
        else
          render json: { status: :error, message: 'error', data: photo.errors }
        end
      end

      private

      def photo_params
        params.require(:photo).permit(:password, images: [])
      end
    end
  end
end
