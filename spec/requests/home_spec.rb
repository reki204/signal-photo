require 'rails_helper'

RSpec.describe "Homes", type: :request do
  describe "GET /index" do
    it 'return http success' do
      get '/'
      expect(response).to have_http_status(:success)
    end
  end
end
