class PhotosController < ApplicationController
  before_action :authenticate_user!, except: :index

  def index
    # @tweets = Photo.password_matches?(params[:search])
    @tweets = Photo.all
    @decrypted_images = []

    @tweets.each do |tweet|
      decrypted_images = tweet.images.map do |image|
        binding.pry
        decrypted_data = tweet.decrypt_and_decode_to_image('mike_encrypted.json', @encrypt_password, @salt)
        puts "decrypted_dataの型はこれです。 #{decrypted_data.class}" 
      end
      @decrypted_images << decrypted_images
    end
    puts "@decrypted_imageは以下です。 #{@decrypted_images}"
  end

  def new
    @tweet = Photo.new
  end

  def create
    @tweet = Photo.new(photo_params)
    @tweet.user_id = current_user.id
    uploaded_file_info = @tweet.images.first
    image_path = uploaded_file_info.path

    binding.pry
    @tweet.encrypt_and_save_image_to_json(image_path, @encrypt_password, @salt, "#{@tweet.password}_encrypted.json")

    if @tweet.save
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

  def set_encryption_variables
    @encrypt_password ||= SecureRandom.hex(16)
    @salt ||= SecureRandom.hex(8)
  end
end
