require 'rails_helper'

RSpec.describe "Listings", type: :request do
  let(:seller) { User.create!(email: 'seller@test.com', password: 'password123') }
    
  describe "GET /listings" do
    let!(:listing) { Listing.create!(title: 'laptop', price: 1000, user: seller) }
    
    it "reads all listings" do
      get listings_path
      expect(response).to have_http_status(:ok)
    end

    it "reads a single listing" do
      get listing_path(listing)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('laptop')
    end
  end
  
  describe "POST /listings" do
    before do
      allow_any_instance_of(ListingsController)
        .to receive(:current_user).and_return(seller)
    end
    
    it "creates a new listing" do
      expect {
        post listings_path, params: { listing: { title: 'Bike', price: 200 } }
      }.to change(Listing, :count).by(1)
      
      expect(response).to redirect_to(listing_path(Listing.last))
    end
  end
  
  describe "PUT /listings/:id" do
    let!(:listing) { Listing.create!(title: 'Old', price: 100, user: seller) }
    
    before do
      allow_any_instance_of(ListingsController)
        .to receive(:current_user).and_return(seller)
    end
    
    it "updates the listing" do
      put listing_path(listing), params: { listing: { title: 'New' } }
      
      listing.reload
      expect(listing.title).to eq('New')
    end
  end
  
  describe "DELETE /listings/:id" do
    let!(:listing) { Listing.create!(title: 'Delete Me', price: 50, user: seller) }
    
    before do
      allow_any_instance_of(ListingsController)
        .to receive(:current_user).and_return(seller)
    end
    
    it "deletes the listing" do
      expect {
        delete listing_path(listing)
      }.to change(Listing, :count).by(-1)
    end

  end
end
