require 'rails_helper'

RSpec.describe Photo, type: :model do
  describe 'photo' do
    before do
      @photo = build(:photo)
    end

    context 'when valid parameters' do
      it 'all fields are filled in' do
        expect(@photo).to be_valid
      end
    end

    context 'when invalid parameters' do
      it 'not all fields are filled in.' do
        @photo = Photo.new
        expect(@photo.save).to be_falsey
      end
    end
  end
end
