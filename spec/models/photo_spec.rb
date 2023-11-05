require 'rails_helper'

RSpec.describe Photo, type: :model do
  describe 'photo' do
    let(:user) { create(:user) }
    let(:photo) { build(:photo, user: user) }

    context 'when valid parameters' do
      it 'belongs to user' do
        expect(photo.user).to eq user
      end

      it 'mounts image uploader' do
        expect(photo.image).to be_a ImageUploader
      end

      it 'all fields are filled in' do
        expect(photo).to be_valid
      end
    end

    context 'when invalid parameters' do
      it 'is invalid without password' do
        photo.password = nil
        photo.valid?
        expect(photo.errors[:password]).to include("can't be blank")
      end

      it 'is invalid without image' do
        photo.image = nil
        photo.valid?
        expect(photo.errors[:image]).to include("can't be blank")
      end

      it 'not all fields are filled in' do
        photo = Photo.new
        expect(photo.save).to be_falsey
      end
    end
  end
end
