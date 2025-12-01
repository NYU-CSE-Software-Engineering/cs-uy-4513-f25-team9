require 'rails_helper'

RSpec.describe "User Login and Registration", type: :request do
  describe "GET /users/new" do
    it "renders the sign up page" do
      get '/users/new'
      expect(response).to have_http_status(:ok)
    end
  end
end
