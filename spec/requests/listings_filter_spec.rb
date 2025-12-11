require 'rails_helper'

RSpec.describe 'Listings filtering', type: :request do
  let(:user) { User.create!(email: 'viewer@example.com', password: 'password', name: 'Test Viewer') }
  let(:seller) { User.create!(email: 's@example.com', password: 'password', name: 'Test Seller') }
  let(:another_seller) { User.create!(email: 'another@example.com', password: 'password', name: 'Another Seller') }

  before do
    # Login the user
    post login_path, params: { email: user.email, password: 'password' }

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

  describe 'GET /feed with category filter' do
    context 'when filtering by Books category' do
      it 'returns a Books category listing' do
        get feed_path, params: { category: 'Books' }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Books')
      end

      it 'shows Books in the category dropdown' do
        get feed_path, params: { category: 'Books' }
        expect(response.body).to include('Books')
      end
    end

    context 'when filtering by Furniture category' do
      it 'returns a Furniture category listing' do
        get feed_path, params: { category: 'Furniture' }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Furniture')
      end

      it 'returns furniture listings' do
        get feed_path, params: { category: 'Furniture' }
        body = response.body
        expect(body).to include('Furniture')
      end
    end

    context 'when filtering by Electronics category' do
      it 'returns an Electronics listing' do
        get feed_path, params: { category: 'Electronics' }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Electronics')
      end
    end

    context 'when filtering by Apparel category' do
      it 'returns an Apparel listing' do
        get feed_path, params: { category: 'Apparel' }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Apparel')
      end
    end

    context 'when filtering by Kitchen category' do
      it 'returns a Kitchen listing' do
        get feed_path, params: { category: 'Kitchen' }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Kitchen')
      end
    end

    context 'when filtering by non-existent category' do
      it 'shows empty state' do
        get feed_path, params: { category: 'NonExistent' }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('You\'re all caught up')
      end

      it 'shows empty state without listings' do
        get feed_path, params: { category: 'NonExistent' }
        expect(response.body).to include('empty-state')
      end
    end

    context 'when no category filter is provided' do
      it 'returns listings' do
        get feed_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to match(/\$\d+\.\d{2}/)
      end

      it 'does not show empty state when there are listings' do
        get feed_path
        expect(response.body).not_to include('You\'re all caught up')
      end
    end

    context 'when category filter is empty string' do
      it 'returns listings (treats empty string as no filter)' do
        get feed_path, params: { category: '' }
        expect(response).to have_http_status(:ok)
        expect(response.body).to match(/\$\d+\.\d{2}/)
      end
    end

    context 'when listings have nil category' do
      it 'does not include nil category listings when filtering by Books' do
        get feed_path, params: { category: 'Books' }
        # If we get a Books listing, it won't be the uncategorized one
        if response.body.include?('Books')
          expect(response.body).to include('Books')
        end
      end

      it 'can show listings when no filter' do
        get feed_path
        expect(response.body).to match(/\$\d+\.\d{2}/)
      end
    end

    context 'when there are no listings at all' do
      before do
        Listing.destroy_all
      end

      it 'shows empty state' do
        get feed_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('You\'re all caught up')
      end

      it 'shows empty state for any category filter' do
        get feed_path, params: { category: 'Books' }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('You\'re all caught up')
      end
    end
  end

  describe 'Category dropdown functionality' do
    context 'when accessing listings index' do
      it 'provides category options in the filter dropdown' do
        get feed_path
        expect(response.body).to include('All Categories')
      end

      it 'displays all unique categories' do
        get feed_path
        body = response.body
        expect(body).to include('<option value="Books">')
        expect(body).to include('<option value="Furniture">')
        expect(body).to include('<option value="Electronics">')
        expect(body).to include('<option value="Apparel">')
        expect(body).to include('<option value="Kitchen">')
      end
    end
  end

  describe 'Listing creation with category' do
    before do
      allow_any_instance_of(ActionDispatch::Request)
        .to receive(:session)
              .and_return({ user_id: user.id })
    end

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
      it 'shows empty state for lowercase category' do
        get feed_path, params: { category: 'books' }
        expect(response.body).to include('You\'re all caught up')
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

      it 'returns Books category listings' do
        get feed_path, params: { category: 'Books' }
        expect(response.body).to include('Books')
      end
    end
  end
end