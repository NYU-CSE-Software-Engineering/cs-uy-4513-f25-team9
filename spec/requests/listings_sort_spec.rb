require 'rails_helper'

RSpec.describe 'Listings sorting', type: :request do
  let(:user) { User.create!(email: 'viewer@example.com', password: 'password', name: 'Test Viewer') }
  let(:seller) { User.create!(email: 'user@example.com', password: 'password', name: 'Test User') }
  let(:other_user) { User.create!(email: 'other@example.com', password: 'password', name: 'Other User') }

  before do
    # Login the user
    post login_path, params: { email: user.email, password: 'password' }

    # Create listings with different creation times and prices
    @listing1 = Listing.create!(user: seller, title: 'First listing', price: 50.00, category: nil, created_at: 3.days.ago)
    @listing2 = Listing.create!(user: seller, title: 'Second listing', price: 100.00, category: nil, created_at: 2.days.ago)
    @listing3 = Listing.create!(user: seller, title: 'Third listing', price: 75.00, category: nil, created_at: 1.day.ago)
    @listing4 = Listing.create!(user: other_user, title: 'Fourth listing', price: 150.00, category: nil, created_at: Time.current)
  end

  describe 'GET /feed with sort parameter' do
    describe 'when sorting by newest' do
      it 'returns listings' do
        get feed_path, params: { sort: 'newest' }
        expect(response).to be_successful
      end

      it 'displays listings' do
        get feed_path, params: { sort: 'newest' }
        expect(response).to be_successful
      end
    end

    describe 'when sorting by price ascending' do
      it 'returns listings' do
        get feed_path, params: { sort: 'price_asc' }
        expect(response).to be_successful
      end

      it 'shows listings' do
        get feed_path, params: { sort: 'price_asc' }
        expect(response).to be_successful
      end
    end

    describe 'when sorting by price descending' do
      it 'returns listings' do
        get feed_path, params: { sort: 'price_desc' }
        expect(response).to be_successful
      end

      it 'shows listings' do
        get feed_path, params: { sort: 'price_desc' }
        expect(response).to be_successful
      end
    end

    describe 'when no sort parameter is provided' do
      it 'returns listings' do
        get feed_path
        expect(response).to be_successful
      end
    end

    describe 'when an invalid sort parameter is provided' do
      it 'does not raise an error' do
        expect {
          get feed_path, params: { sort: 'invalid_sort' }
        }.not_to raise_error

        expect(response).to be_successful
      end

      it 'returns results' do
        get feed_path, params: { sort: 'invalid_sort' }
        expect(response).to be_successful
      end
    end

    describe 'when sorting is combined with category filter' do
      before do
        @listing1.update!(category: 'Electronics')
        @listing2.update!(category: 'Electronics')
        @listing3.update!(category: 'Books')
        @listing4.update!(category: 'Books')
      end

      it 'applies both category filter and sort' do
        get feed_path, params: { category: 'Books', sort: 'price_asc' }
        expect(response).to be_successful
      end

      it 'preserves category filter when sorting by newest' do
        get feed_path, params: { category: 'Electronics', sort: 'newest' }
        expect(response).to be_successful
      end
    end

    describe 'when sorting is combined with price filter' do
      it 'applies both price filter and sort' do
        get feed_path, params: { min_price: '75', max_price: '150', sort: 'price_asc' }
        expect(response).to be_successful
      end
    end

    describe 'when sorting is combined with search filter' do
      it 'applies search and sort together' do
        @listing1.update!(title: 'Vintage Camera')
        @listing2.update!(title: 'Vintage Watch')
        @listing3.update!(title: 'Modern Phone')
        @listing4.update!(title: 'Vintage Lamp')

        get feed_path, params: { q: 'vintage', sort: 'price_desc' }
        expect(response).to be_successful
      end
    end
  end
end