require 'rails_helper'

RSpec.describe 'Listings filtering', type: :request do
  let(:seller) { User.create!(email: 's@example.com', password: 'password') }

  before do
    Listing.create!(title: 'Book A', price: 10.00, user: seller, category: 'Books')
    Listing.create!(title: 'Chair',  price: 20.00, user: seller, category: 'Furniture')
    Listing.create!(title: 'Book B', price: 12.00, user: seller, category: 'Books')
  end

  it 'returns only listings from the selected category' do
    get '/listings', params: { category: 'Books' }
    expect(response).to have_http_status(:ok)
    expect(response.body).to include('Book A')
    expect(response.body).to include('Book B')
    expect(response.body).not_to include('Chair')
  end

  it 'shows a message if no listings match' do
    get '/listings', params: { category: 'Electronics' }
    expect(response.body).to include('No listings found in this category.')
  end
end
