class PhotosController < ApplicationController
  before_action :authenticate_user!, except: :index

  def index
    @tweets = Photo.password_matches?(params[:search]).order(created_at: :desc)
    @decrypted_images = []

    @tweets.each do |tweet|
      decrypted_images = tweet.images.map do |image|
        {
          tweet: tweet,
          image_data: tweet.decrypt_and_decode_to_image("public/#{tweet.password}/encrypted_#{tweet.id}.json", tweet.encrypt_password, tweet.salt)
        }
      end
      @decrypted_images.concat(decrypted_images)
    end
  end

  def new
    @tweet = Photo.new
  end

  def create
    @tweet = Photo.new(photo_params)
    @tweet.user_id = current_user.id
    uploaded_file_info = @tweet.images.first
    image_path = uploaded_file_info.path

    @tweet.generate_encrypt_password_and_salt
    
    if @tweet.save
      @tweet.encrypt_and_save_image_to_json(uploaded_file_info.path, "public/#{@tweet.password}/encrypted_#{@tweet.id}.json")
      redirect_to photos_path, notice: '画像を投稿しました。'
    else
      render :new
    end
  end

  def destroy
    tweet = Photo.find(params[:id])
    tweet.destroy
    redirect_to action: :index, notice: '画像を削除しました。'
  end

  private
  def photo_params
    params.require(:photo).permit(:password, images: [])
  end
end
