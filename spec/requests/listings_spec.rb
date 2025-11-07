require 'rails_helper'

RSpec.describe "Listings", type: :request do
  describe "GET /" do
    it "renders the listings index page" do
      get root_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("All Listings")
    end
  end
end
