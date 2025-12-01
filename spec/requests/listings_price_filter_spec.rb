require 'rails_helper'

RSpec.describe 'Listings price filtering', type: :request do
  let(:seller) { User.create!(email: 's@example.com', password: 'password', name: 'Seller') }

  before do
    # Create listings at different price points
    Listing.create!(title: 'Cheap Item', price: 5.00, user: seller, category: 'Books')
    Listing.create!(title: 'Mid-range Item', price: 50.00, user: seller, category: 'Books')
    Listing.create!(title: 'Expensive Item', price: 200.00, user: seller, category: 'Books')
    Listing.create!(title: 'Very Cheap', price: 1.00, user: seller, category: 'Electronics')
    Listing.create!(title: 'Very Expensive', price: 999.00, user: seller, category: 'Furniture')
  end

  describe 'Listing.by_price_range scope' do
    context 'when filtering by price range' do
      it 'returns listings within the price range (min_price only)' do
        results = Listing.by_price_range(min_price: 50.00)
        expect(results.count).to eq(3)
        expect(results.pluck(:title)).to include('Mid-range Item', 'Expensive Item', 'Very Expensive')
        expect(results.pluck(:title)).not_to include('Cheap Item', 'Very Cheap')
      end

      it 'returns listings within the price range (max_price only)' do
        results = Listing.by_price_range(max_price: 100.00)
        expect(results.count).to eq(4)
        expect(results.pluck(:title)).to include('Cheap Item', 'Mid-range Item', 'Very Cheap')
        expect(results.pluck(:title)).not_to include('Expensive Item', 'Very Expensive')
      end

      it 'returns listings within price range (both min and max)' do
        results = Listing.by_price_range(min_price: 10.00, max_price: 100.00)
        expect(results.count).to eq(2)
        expect(results.pluck(:title)).to include('Mid-range Item')
        expect(results.pluck(:title)).not_to include('Cheap Item', 'Expensive Item', 'Very Cheap', 'Very Expensive')
      end

      it 'returns all listings when no price filter provided' do
        results = Listing.by_price_range(min_price: nil, max_price: nil)
        expect(results.count).to eq(5)
      end

      it 'returns empty when min_price is higher than all listings' do
        results = Listing.by_price_range(min_price: 1000.00)
        expect(results.count).to eq(0)
      end

      it 'returns empty when max_price is lower than all listings' do
        results = Listing.by_price_range(max_price: 0.50)
        expect(results.count).to eq(0)
      end
    end
  end

  describe 'GET /listings with price filter' do
    context 'when filtering by min_price' do
      it 'returns only listings above minimum price' do
        get '/listings', params: { min_price: '50' }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Mid-range Item')
        expect(response.body).to include('Expensive Item')
        expect(response.body).not_to include('Cheap Item')
      end
    end

    context 'when filtering by max_price' do
      it 'returns only listings below maximum price' do
        get '/listings', params: { max_price: '100' }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Cheap Item')
        expect(response.body).to include('Mid-range Item')
        expect(response.body).not_to include('Expensive Item')
      end
    end

    context 'when filtering by both min and max price' do
      it 'returns listings within price range' do
        get '/listings', params: { min_price: '10', max_price: '100' }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Mid-range Item')
        expect(response.body).not_to include('Cheap Item')
        expect(response.body).not_to include('Expensive Item')
      end
    end

    context 'when combining category and price filters' do
      it 'returns listings matching both filters' do
        get '/listings', params: { category: 'Books', min_price: '10', max_price: '100' }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Mid-range Item')
        expect(response.body).not_to include('Cheap Item')
        expect(response.body).not_to include('Very Expensive')
      end
    end
  end
end
