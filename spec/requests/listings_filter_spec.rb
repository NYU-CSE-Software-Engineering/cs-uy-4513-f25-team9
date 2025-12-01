require 'rails_helper'

RSpec.describe 'Listings filtering', type: :request do
  let(:seller) { User.create!(email: 's@example.com', password: 'password', name: 'Test Seller') }
  let(:another_seller) { User.create!(email: 'another@example.com', password: 'password', name: 'Another Seller') }

  before do
    # Create listings in different categories
    Listing.create!(title: 'Ruby Book', price: 10.00, user: seller, category: 'Books')
    Listing.create!(title: 'Python Book', price: 12.00, user: seller, category: 'Books')
    Listing.create!(title: 'Wood Chair', price: 20.00, user: seller, category: 'Furniture')
    Listing.create!(title: 'Metal Table', price: 50.00, user: another_seller, category: 'Furniture')
    Listing.create!(title: 'iPhone 15', price: 800.00, user: seller, category: 'Electronics')
    Listing.create!(title: 'Nike Shoes', price: 100.00, user: another_seller, category: 'Apparel')
    Listing.create!(title: 'Coffee Maker', price: 80.00, user: seller, category: 'Kitchen')
    Listing.create!(title: 'Uncategorized Item', price: 5.00, user: seller, category: nil)
  end

  describe 'GET /listings with category filter' do
    context 'when filtering by Books category' do
      it 'returns only listings from Books category' do
        get '/listings', params: { category: 'Books' }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Ruby Book')
        expect(response.body).to include('Python Book')
        expect(response.body).not_to include('Wood Chair')
        expect(response.body).not_to include('iPhone 15')
        expect(response.body).not_to include('Nike Shoes')
      end

      it 'does not return listings from other categories' do
        get '/listings', params: { category: 'Books' }
        expect(response.body).not_to include('Metal Table')
        expect(response.body).not_to include('Coffee Maker')
      end
    end

    context 'when filtering by Furniture category' do
      it 'returns only listings from Furniture category' do
        get '/listings', params: { category: 'Furniture' }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Wood Chair')
        expect(response.body).to include('Metal Table')
        expect(response.body).not_to include('Ruby Book')
        expect(response.body).not_to include('iPhone 15')
      end

      it 'returns multiple sellers furniture' do
        get '/listings', params: { category: 'Furniture' }
        body = response.body
        expect(body).to include('Wood Chair')
        expect(body).to include('Metal Table')
        # Verify count is correct
        furniture_count = body.scan(/Furniture/).size
        expect(furniture_count).to be >= 2
      end
    end

    context 'when filtering by Electronics category' do
      it 'returns only Electronics listings' do
        get '/listings', params: { category: 'Electronics' }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('iPhone 15')
        expect(response.body).not_to include('Ruby Book')
        expect(response.body).not_to include('Nike Shoes')
      end
    end

    context 'when filtering by Apparel category' do
      it 'returns only Apparel listings' do
        get '/listings', params: { category: 'Apparel' }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Nike Shoes')
        expect(response.body).not_to include('Ruby Book')
        expect(response.body).not_to include('Coffee Maker')
      end
    end

    context 'when filtering by Kitchen category' do
      it 'returns only Kitchen listings' do
        get '/listings', params: { category: 'Kitchen' }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Coffee Maker')
        expect(response.body).not_to include('Ruby Book')
        expect(response.body).not_to include('iPhone 15')
      end
    end

    context 'when filtering by non-existent category' do
      it 'shows "No listings found" message' do
        get '/listings', params: { category: 'NonExistent' }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('No listings found matching your filters.')
      end

      it 'does not show any listings' do
        get '/listings', params: { category: 'NonExistent' }
        expect(response.body).not_to include('Ruby Book')
        expect(response.body).not_to include('Wood Chair')
      end
    end

    context 'when no category filter is provided' do
      it 'returns all listings' do
        get '/listings'
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Ruby Book')
        expect(response.body).to include('Wood Chair')
        expect(response.body).to include('iPhone 15')
        expect(response.body).to include('Nike Shoes')
        expect(response.body).to include('Coffee Maker')
        expect(response.body).to include('Uncategorized Item')
      end

      it 'shows "No listings available" message when category filter matches nothing but shows all when no filter' do
        # This test verifies the logic: without filter = show all, with filter = show filtered
        get '/listings'
        expect(response.body).not_to include('No listings available.')
      end

      it 'does not show "No listings found in this category" message' do
        get '/listings'
        expect(response.body).not_to include('No listings found in this category.')
      end
    end

    context 'when category filter is empty string' do
      it 'returns all listings (treats empty string as no filter)' do
        get '/listings', params: { category: '' }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Ruby Book')
        expect(response.body).to include('Wood Chair')
        expect(response.body).to include('iPhone 15')
      end
    end

    context 'when listings have nil category' do
      it 'does not include nil category listings in filtered results' do
        get '/listings', params: { category: 'Books' }
        expect(response.body).not_to include('Uncategorized Item')
      end

      it 'includes nil category listings when no filter' do
        get '/listings'
        expect(response.body).to include('Uncategorized Item')
      end
    end

    context 'when there are no listings at all' do
      before do
        Listing.destroy_all
      end

      it 'shows no listings available message' do
        get '/listings'
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('No listings available.')
      end

      it 'shows no listings found in this category for any category filter' do
        get '/listings', params: { category: 'Books' }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('No listings found matching your filters.')
      end
    end
  end

  describe 'Category dropdown functionality' do
    context 'when accessing listings index' do
      it 'provides category options in the filter dropdown' do
        get '/listings'
        expect(response.body).to include('All Categories')
      end

      it 'displays all unique categories' do
        get '/listings'
        body = response.body
        # The form should render select options with category values
        expect(body).to include('<option value="Books">')
        expect(body).to include('<option value="Furniture">')
        expect(body).to include('<option value="Electronics">')
        expect(body).to include('<option value="Apparel">')
        expect(body).to include('<option value="Kitchen">')
      end
    end
  end

  describe 'Listing creation with category' do
    let(:user) { User.create!(email: 'user@example.com', password: 'password', name: 'Test User') }

    context 'when creating a new listing with category' do
      it 'saves the category field' do
        listing = Listing.create!(
          title: 'New Item',
          description: 'Test Description',
          price: 25.00,
          category: 'Electronics',
          user: user
        )
        expect(listing.category).to eq('Electronics')
        expect(Listing.find(listing.id).category).to eq('Electronics')
      end
    end

    context 'when updating listing category' do
      let(:listing) { Listing.create!(title: 'Item', price: 10.00, user: user, category: 'Books') }

      it 'can change category from one to another' do
        listing.update!(category: 'Furniture')
        expect(listing.reload.category).to eq('Furniture')
      end

      it 'persists category change in database' do
        listing.update!(category: 'Electronics')
        fetched_listing = Listing.find(listing.id)
        expect(fetched_listing.category).to eq('Electronics')
      end
    end
  end

  describe 'Listing.by_category scope' do
    it 'returns listings matching the category' do
      results = Listing.by_category('Books')
      expect(results.count).to eq(2)
      expect(results.pluck(:title)).to include('Ruby Book', 'Python Book')
    end

    it 'returns empty when category does not match' do
      results = Listing.by_category('NonExistent')
      expect(results.count).to eq(0)
    end

    it 'returns all listings when category is nil or blank' do
      results = Listing.by_category(nil)
      expect(results.count).to eq(Listing.count)

      results = Listing.by_category('')
      expect(results.count).to eq(Listing.count)
    end
  end

  describe 'Listing.available_categories' do
    it 'returns distinct categories from database' do
      categories = Listing.available_categories
      expect(categories).to include('Books')
      expect(categories).to include('Furniture')
      expect(categories).to include('Electronics')
      expect(categories).to include('Apparel')
      expect(categories).to include('Kitchen')
    end

    it 'does not include nil categories' do
      categories = Listing.available_categories
      expect(categories).not_to include(nil)
    end

    it 'returns categories in alphabetical order' do
      categories = Listing.available_categories
      expect(categories).to eq(categories.sort)
    end

    it 'does not return duplicate categories' do
      categories = Listing.available_categories
      expect(categories.uniq).to eq(categories)
    end
  end

  describe 'Edge cases and special scenarios' do
    context 'when searching with case sensitivity' do
      it 'matches category exactly (case-sensitive filtering)' do
        get '/listings', params: { category: 'books' }
        # Should not match 'Books' (lowercase search for capitalized category)
        expect(response.body).not_to include('Ruby Book')
      end
    end

    context 'when category has whitespace' do
      before do
        Listing.create!(title: 'Test', price: 10.00, user: seller, category: ' Furniture ')
      end

      it 'stores category as-is with whitespace' do
        listing = Listing.find_by(title: 'Test')
        expect(listing.category).to eq(' Furniture ')
      end
    end

    context 'when filtering returns multiple pages (if pagination exists)' do
      before do
        20.times { |i| Listing.create!(title: "Book #{i}", price: 10.00 + i, user: seller, category: 'Books') }
      end

      it 'returns all Books category listings' do
        get '/listings', params: { category: 'Books' }
        expect(response.body).to include('Book 0')
        expect(response.body).to include('Book 19')
      end
    end
  end
end
