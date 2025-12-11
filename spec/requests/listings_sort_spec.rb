require 'rails_helper'

RSpec.describe 'Listings sorting', type: :request do
  let(:user) { User.create!(email: 'user@example.com', password: 'password', name: 'Test User') }
  let(:other_user) { User.create!(email: 'other@example.com', password: 'password', name: 'Other User') }

  before do
    # Create listings with different creation times and prices
    @listing1 = Listing.create!(user: user, title: 'First listing', price: 50.00, category: nil, created_at: 3.days.ago)
    @listing2 = Listing.create!(user: user, title: 'Second listing', price: 100.00, category: nil, created_at: 2.days.ago)
    @listing3 = Listing.create!(user: user, title: 'Third listing', price: 75.00, category: nil, created_at: 1.day.ago)
    @listing4 = Listing.create!(user: other_user, title: 'Fourth listing', price: 150.00, category: nil, created_at: Time.current)
  end

  describe 'GET /listings with sort parameter' do
    describe 'when sorting by newest' do
      it 'returns listings ordered by creation date descending (newest first)' do
        get '/listings', params: { sort: 'newest' }

        expect(response).to be_successful
        body = response.body
        
        # Extract listing IDs from the response in order
        # Newest listing (@listing4) should appear before older ones
        listing4_position = body.index("Fourth listing")
        listing3_position = body.index("Third listing")
        listing2_position = body.index("Second listing")
        listing1_position = body.index("First listing")
        
        expect(listing4_position).to be < listing3_position
        expect(listing3_position).to be < listing2_position
        expect(listing2_position).to be < listing1_position
      end

      it 'displays newest listings first in the listing table' do
        get '/listings', params: { sort: 'newest' }

        expect(response).to be_successful
        expect(response.body).to include('Fourth listing')
      end
    end

    describe 'when sorting by price ascending' do
      it 'returns listings ordered by price ascending (lowest first)' do
        get '/listings', params: { sort: 'price_asc' }

        expect(response).to be_successful
        body = response.body
        
        # Lowest price (@listing1 = $50) should appear before highest (@listing4 = $150)
        listing1_position = body.index('$50')
        listing3_position = body.index('$75')
        listing2_position = body.index('$100')
        listing4_position = body.index('$150')
        
        expect(listing1_position).to be < listing3_position
        expect(listing3_position).to be < listing2_position
        expect(listing2_position).to be < listing4_position
      end

      it 'shows lowest priced item first' do
        get '/listings', params: { sort: 'price_asc' }

        expect(response).to be_successful
        # First listing at $50 should be shown first
        body = response.body
        listing1_position = body.index('$50')
        listing2_position = body.index('$100')
        
        expect(listing1_position).to be < listing2_position
      end
    end

    describe 'when sorting by price descending' do
      it 'returns listings ordered by price descending (highest first)' do
        get '/listings', params: { sort: 'price_desc' }

        expect(response).to be_successful
        body = response.body
        
        # Highest price (@listing4 = $150) should appear before lowest (@listing1 = $50)
        listing4_position = body.index('$150')
        listing2_position = body.index('$100')
        listing3_position = body.index('$75')
        listing1_position = body.index('$50')
        
        expect(listing4_position).to be < listing2_position
        expect(listing2_position).to be < listing3_position
        expect(listing3_position).to be < listing1_position
      end

      it 'shows highest priced item first' do
        get '/listings', params: { sort: 'price_desc' }

        expect(response).to be_successful
        body = response.body
        listing4_position = body.index('$150')
        listing1_position = body.index('$50')
        
        expect(listing4_position).to be < listing1_position
      end
    end

    describe 'when no sort parameter is provided' do
      it 'defaults to newest (created_at desc)' do
        get '/listings'

        expect(response).to be_successful
        body = response.body
        
        # Should default to newest first
        listing4_position = body.index("Fourth listing")
        listing1_position = body.index("First listing")
        
        expect(listing4_position).to be < listing1_position
      end
    end

    describe 'when an invalid sort parameter is provided' do
      it 'defaults to newest and does not raise an error' do
        expect {
          get '/listings', params: { sort: 'invalid_sort' }
        }.not_to raise_error

        expect(response).to be_successful
      end

      it 'returns results in newest order when sort is invalid' do
        get '/listings', params: { sort: 'invalid_sort' }

        expect(response).to be_successful
        body = response.body
        
        # Should fall back to newest first
        listing4_position = body.index("Fourth listing")
        listing1_position = body.index("First listing")
        
        expect(listing4_position).to be < listing1_position
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
        get '/listings', params: { category: 'Books', sort: 'price_asc' }

        expect(response).to be_successful
        body = response.body
        
        # Should have Books category listings, sorted by price ascending
        # Books listings: @listing3 ($75) and @listing4 ($150)
        listing3_position = body.index('$75')
        listing4_position = body.index('$150')
        
        # $75 should come before $150
        expect(listing3_position).to be < listing4_position
        
        # Should NOT include Electronics listings
        expect(body).not_to include("First listing")  # $50, Electronics
        expect(body).not_to include("Second listing")  # $100, Electronics
      end

      it 'preserves category filter when sorting by newest' do
        get '/listings', params: { category: 'Electronics', sort: 'newest' }

        expect(response).to be_successful
        body = response.body
        
        # Should only show Electronics listings
        expect(body).to include("First listing")
        expect(body).to include("Second listing")
        expect(body).not_to include("Third listing")
        expect(body).not_to include("Fourth listing")
        
        # Should be ordered by newest first
        listing2_position = body.index("Second listing")
        listing1_position = body.index("First listing")
        
        expect(listing2_position).to be < listing1_position
      end
    end

    describe 'when sorting is combined with price filter' do
      it 'applies both price filter and sort' do
        get '/listings', params: { min_price: '75', max_price: '150', sort: 'price_asc' }

        expect(response).to be_successful
        body = response.body
        
        # Should have listings in $75-$150 range, sorted by price ascending
        # Matching listings: @listing3 ($75), @listing2 ($100), @listing4 ($150)
        listing3_position = body.index('$75')
        listing2_position = body.index('$100')
        listing4_position = body.index('$150')
        
        expect(listing3_position).to be < listing2_position
        expect(listing2_position).to be < listing4_position
        
        # Should NOT include listing outside price range
        expect(body).not_to include("First listing")  # $50
      end
    end

    describe 'when sorting is combined with search filter' do
      it 'applies search and sort together' do
        @listing1.update!(title: 'Vintage Camera')
        @listing2.update!(title: 'Vintage Watch')
        @listing3.update!(title: 'Modern Phone')
        @listing4.update!(title: 'Vintage Lamp')
        
        get '/listings', params: { q: 'vintage', sort: 'price_desc' }

        expect(response).to be_successful
        body = response.body
        
        # Should have Vintage items sorted by price descending
        # Vintage items: @listing1 ($50), @listing2 ($100), @listing4 ($150)
        listing4_position = body.index('$150')
        listing2_position = body.index('$100')
        listing1_position = body.index('$50')
        
        expect(listing4_position).to be < listing2_position
        expect(listing2_position).to be < listing1_position
        
        # Should NOT include the non-Vintage item
        expect(body).not_to include("Modern Phone")
      end
    end
  end

  describe 'sort parameter persistence in view' do
    it 'displays sort dropdown in the filter form' do
      get '/listings'

      expect(response).to be_successful
      expect(response.body).to include('sort')
    end

    it 'shows all sort options in dropdown' do
      get '/listings'

      expect(response).to be_successful
      body = response.body
      
      expect(body).to include('newest')
      expect(body).to include('price_asc')
      expect(body).to include('price_desc')
    end

    it 'maintains sort parameter in form submission' do
      get '/listings', params: { sort: 'price_asc' }

      expect(response).to be_successful
      # Sort parameter should be present for form submission
      expect(response.body).to include('name="sort"')
    end
  end
end
