require 'rails_helper'

RSpec.describe 'Listings search', type: :request do
  let(:user) { User.create!(email: 'viewer@example.com', password: 'password', name: 'Test Viewer') }
  let(:seller) { User.create!(email: 's@example.com', password: 'password', name: 'Seller') }

  before do
    # Login the user
    post login_path, params: { email: user.email, password: 'password' }

    # Create listings with different titles and descriptions
    Listing.create!(
      title: 'iPhone 15 Pro Max',
      description: 'Excellent condition, barely used smartphone',
      price: 800.00,
      user: seller,
      category: 'Electronics'
    )
    Listing.create!(
      title: 'Vintage Book Collection',
      description: 'Rare and vintage books from the 1950s',
      price: 150.00,
      user: seller,
      category: 'Books'
    )
    Listing.create!(
      title: 'Wooden Coffee Table',
      description: 'Beautiful vintage wooden furniture piece',
      price: 200.00,
      user: seller,
      category: 'Furniture'
    )
    Listing.create!(
      title: 'Winter Jacket',
      description: 'Warm and stylish winter clothing',
      price: 60.00,
      user: seller,
      category: 'Apparel'
    )
    Listing.create!(
      title: 'Kitchen Knife Set',
      description: 'Professional kitchen tool set',
      price: 45.00,
      user: seller,
      category: 'Kitchen'
    )
  end

  describe 'Listing.by_search scope' do
    context 'when searching in title' do
      it 'returns listings matching search term in title' do
        results = Listing.by_search('iPhone')
        expect(results.count).to eq(1)
        expect(results.pluck(:title)).to include('iPhone 15 Pro Max')
      end

      it 'returns multiple listings matching search term' do
        results = Listing.by_search('book')
        expect(results.count).to eq(1)
        expect(results.pluck(:title)).to include('Vintage Book Collection')
      end
    end

    context 'when searching in description' do
      it 'returns listings matching search term in description' do
        results = Listing.by_search('vintage')
        expect(results.count).to eq(2)
        expect(results.pluck(:title)).to include('Vintage Book Collection', 'Wooden Coffee Table')
      end

      it 'returns listings when term appears in description only' do
        results = Listing.by_search('furniture')
        expect(results.count).to eq(1)
        expect(results.first.title).to eq('Wooden Coffee Table')
      end
    end

    context 'when search term is case insensitive' do
      it 'matches lowercase search in uppercase title' do
        results = Listing.by_search('iphone')
        expect(results.count).to eq(1)
      end

      it 'matches uppercase search in lowercase description' do
        results = Listing.by_search('EXCELLENT')
        expect(results.count).to eq(1)
      end
    end

    context 'when no search results' do
      it 'returns empty collection when no matches' do
        results = Listing.by_search('nonexistent')
        expect(results.count).to eq(0)
      end
    end

    context 'when search is blank or nil' do
      it 'returns all listings when search is nil' do
        results = Listing.by_search(nil)
        expect(results.count).to eq(5)
      end

      it 'returns all listings when search is empty string' do
        results = Listing.by_search('')
        expect(results.count).to eq(5)
      end
    end
  end

  describe 'GET /listings with search query' do
    context 'when searching for products' do
      it 'returns listings matching search query' do
        get feed_path, params: { q: 'iPhone' }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Electronics')
      end

      it 'searches case-insensitively' do
        get feed_path, params: { q: 'vintage' }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('vintage')
      end
    end

    context 'when combining search with category filter' do
      it 'returns listings matching both search and category' do
        get feed_path, params: { q: 'vintage', category: 'Books' }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Books')
      end
    end

    context 'when combining search with price filter' do
      it 'returns listings matching search and price range' do
        get feed_path, params: { q: 'vintage', min_price: '100', max_price: '150' }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('vintage')
      end
    end

    context 'when search returns no results' do
      it 'shows empty state when search returns no results' do
        get feed_path, params: { q: 'nonexistent' }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('You\'re all caught up')  # Changed this line
      end
    end
  end
end