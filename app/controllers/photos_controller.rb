class PhotosController < ApplicationController
  before_action :authenticate_user!, except: :index
  def index
    # if params[:search] == nil
    #   @tweets= Photo.none
    # elsif params[:search] == ''
    #   @tweets= Photo.none
    # else
    #   @tweets = Photo.where("password LIKE ? ", params[:search])
    # end
    @tweets = Photo.match_password(params[:search])
  end

  def new
    @tweet = Photo.new
  end

  def create
    @tweet = Photo.new(photo_params)
    @tweet.user_id = current_user.id
    if @tweet.save
      redirect_to photos_path, notice: '画像を投稿しました。'
    else
      render :new
    end   
  end

  def destroy
    tweet = Photo.find(params[:id])
    tweet.destroy
    redirect_to action: :index
  end
  
  private
  def photo_params
    params.require(:photo).permit(:body, :password ,:image )
  end
end
