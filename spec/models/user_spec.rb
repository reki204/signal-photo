require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'user' do
    before do
      @user = build(:user)
    end
  end

  context 'when valid parameters' do
    it 'all fields are filled in' do
      expect(@user).to be_valid
    end
  end

  context 'when invalid parameters' do
    it 'not all fields are filled in.' do
      @user = User.new
      expect(@user.save).to be_falsey
    end
  end
end
