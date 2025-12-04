require 'rails_helper'

RSpec.describe 'Feed', type: :request do
  let(:buyer)   { User.create!(email: 'buyer@example.com', password: 'password123') }
  let(:seller)  { User.create!(email: 'seller@example.com', password: 'password123') }

  def stub_login(user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe 'GET /feed' do
    it 'requires login' do
      get '/feed'
      expect(response).to redirect_to(login_path)
      expect(response.body).to include('Please sign in')
    end

    it 'shows the next unswiped listing' do
      stub_login(buyer)
      first = Listing.create!(title: 'Old Camera', description: 'Film', price: 50, user: seller, created_at: 2.days.ago)
      recent = Listing.create!(title: 'New Bike', description: 'Fast', price: 200, user: seller, created_at: Time.current)

      get '/feed'
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('New Bike')
      expect(response.body).not_to include('Old Camera') # only one card shown
    end

    it 'excludes listings the buyer owns' do
      own_listing = Listing.create!(title: 'My Item', description: 'Owned', price: 10, user: buyer)
      stub_login(buyer)

      get '/feed'
      expect(response.body).not_to include('My Item')
    end

    it 'excludes already swiped listings' do
      stub_login(buyer)
      listing = Listing.create!(title: 'Swiped Item', description: 'Done', price: 15, user: seller)
      Interest.create!(buyer:, listing:, state: 'liked')

      get '/feed'
      expect(response.body).not_to include('Swiped Item')
    end

    it 'excludes purchased listings' do
      stub_login(buyer)
      listing = Listing.create!(title: 'Sold Item', description: 'Gone', price: 30, user: seller)
      Purchase.create!(buyer:, listing:, price: listing.price, purchased_at: Time.current)

      get '/feed'
      expect(response.body).not_to include('Sold Item')
    end

    it 'honors category and price filters' do
      stub_login(buyer)
      Listing.create!(title: 'Chair', description: 'Wood', price: 20, category: 'Furniture', user: seller)
      Listing.create!(title: 'Laptop', description: 'Gaming', price: 900, category: 'Electronics', user: seller)

      get '/feed', params: { category: 'Furniture', min_price: 10, max_price: 50 }
      expect(response.body).to include('Chair')
      expect(response.body).not_to include('Laptop')
    end

    it 'shows empty state when no listings remain' do
      stub_login(buyer)
      Interest.create!(buyer:, listing: Listing.create!(title: 'Only Item', description: 'One', price: 10, user: seller), state: 'liked')

      get '/feed'
      expect(response.body).to include("You're all caught up")
    end
  end
end
