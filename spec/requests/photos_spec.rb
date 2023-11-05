require 'rails_helper'

RSpec.describe "Photos", type: :request do
  let(:user) { create :user }
  let(:photo) { user.photos.first }

  before do
    sign_in user
  end

  # MEMO: webpackerまわりのエラーのためスルー
  describe 'GET #index' do
    it 'returns http success' do
      get photos_path
      expect(response).to have_http_status(:success)
    end
  end

  # MEMO: webpackerまわりのエラーのためスルー
  describe 'GET #new' do
    it 'returns http success' do
      get new_photo_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    let(:valid_photo_params) { attributes_for(:photo) }
    let(:invalid_photo_params) { attributes_for(:user, body: '') }

    context 'when valid parameters' do
      it 'returns 302 status' do
        post photos_path, params: { photo: valid_photo_params }
        expect(response).to have_http_status(:found)
      end

      it 'increases photo data' do
        expect { post photos_path, params: { photo: valid_photo_params } }.to change(Photo, :count).by(+1)
      end

      it 'redirects to photos page' do
        post photos_path, params: { photo: valid_photo_params }
        expect(response).to redirect_to photos_path
      end
    end

    # MEMO: webpackerまわりのエラーのためスルー
    context 'when invalid parameters' do
      it 'renders new photo page' do
        post photos_path, params: { photo: invalid_photo_params }
        expect(response).to render_template('new')
      end
    end
  end
end
