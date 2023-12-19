class PhotosController < ApplicationController
  before_action :authenticate_user!, except: :index
  def index
    @tweets = Photo.password_matches?(params[:search])
  end

  def new
    @tweet = Photo.new
  end

  def create
    @tweet = Photo.new(photo_params)
    @tweet.user_id = current_user.id
    uploaded_file_info = @tweet.images.first
    image_path = uploaded_file_info.path
    encrypt_password = SecureRandom.hex(16)
    salt = SecureRandom.hex(8)
    # binding.pry
    @tweet.encrypt_and_save_image_to_json(image_path, encrypt_password, salt, 'encrypted.json')
    # @tweet.encrypt_and_save_image_to_json(image_path, 'encrypted.json')

    if @tweet.save
      redirect_to photos_path, notice: '画像を投稿しました。'
    else
      render :new
    end
  end

  def destroy
    tweet = Photo.find(params[:id])
    tweet.destroy
    redirect_to action: :index, notice: '画像を削除しました。', status: :see_other
  end

  private
  def photo_params
    params.require(:photo).permit(:password, images: [])
  end
end
