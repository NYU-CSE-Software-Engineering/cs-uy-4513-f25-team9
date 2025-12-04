require 'rails_helper'

RSpec.describe 'Swipes', type: :request do
  let(:buyer)   { User.create!(email: 'buyer@example.com', password: 'password123') }
  let(:seller)  { User.create!(email: 'seller@example.com', password: 'password123') }
  let(:listing) { Listing.create!(title: 'Swipe Item', description: 'Test', price: 25, user: seller) }

  def stub_login(user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe 'POST /swipes' do
    it 'requires login' do
      post '/swipes', params: { listing_id: listing.id, state: 'liked' }
      expect(response).to redirect_to(login_path)
    end

    it 'creates a like interest' do
      stub_login(buyer)
      expect {
        post '/swipes', params: { listing_id: listing.id, state: 'liked' }
      }.to change(Interest, :count).by(1)

      expect(Interest.last.state).to eq('liked')
      expect(response).to redirect_to('/feed')
    end

    it 'creates a pass interest' do
      stub_login(buyer)
      post '/swipes', params: { listing_id: listing.id, state: 'passed' }
      expect(Interest.last.state).to eq('passed')
    end

    it 'is idempotent on the same listing and buyer' do
      stub_login(buyer)
      Interest.create!(buyer:, listing:, state: 'liked')

      expect {
        post '/swipes', params: { listing_id: listing.id, state: 'passed' }
      }.not_to change(Interest, :count)

      expect(Interest.last.state).to eq('passed')
    end

    it 'rejects invalid states' do
      stub_login(buyer)
      post '/swipes', params: { listing_id: listing.id, state: 'invalid' }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Interest.count).to eq(0)
    end
  end
end
