require 'rails_helper'

RSpec.describe Purchase, type: :model do
  it 'is valid with valid attributes' do
    buyer = User.create!(email: 'buyer@test.com', role: 'buyer', password: 'password123')
    seller = User.create!(email: 'seller@test.com', role: 'seller', password: 'password123')
    listing = Listing.create!(title: 'Test Item', price: 50.00, user: seller)
    
    purchase = Purchase.new(
      buyer: buyer,
      listing: listing,
      price: 50.00,
      purchased_at: Time.current
    )
    
    expect(purchase).to be_valid
  end

  it 'returns empty collection when buyer has no purchases' do
    buyer = User.create!(email: 'buyer@test.com', role: 'buyer', password: 'password123')
    
    expect(buyer.purchases).to be_empty
  end
end