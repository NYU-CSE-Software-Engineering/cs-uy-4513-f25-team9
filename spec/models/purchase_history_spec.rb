require 'rails_helper'

RSpec.describe Purchase, type: :model do
  describe 'associations' do
    it { should belong_to(:buyer).class_name('User') }
    it { should belong_to(:listing) }
  end

  describe 'validations' do
    let(:buyer) { User.create!(email: 'buyer@test.com', password: 'password123') }
    let(:seller) { User.create!(email: 'seller@test.com', password: 'password123') }
    let(:listing) { Listing.create!(title: 'Test Item', price: 50.00, user: seller) }

    it 'is valid with valid attributes' do
      purchase = Purchase.new(
        buyer: buyer,
        listing: listing,
        price: 50.00,
        purchased_at: Time.current
      )
      
      expect(purchase).to be_valid
    end

    it 'requires a buyer' do
      purchase = Purchase.new(
        listing: listing,
        price: 50.00,
        purchased_at: Time.current
      )
      
      expect(purchase).not_to be_valid
      expect(purchase.errors[:buyer]).to be_present
    end

    # Note: listing is optional because it might be deleted after purchase
    # but we still want to validate it exists at creation time
    it 'allows purchase without listing (for deleted listings)' do
      purchase = Purchase.new(
        buyer: buyer,
        price: 50.00,
        purchased_at: Time.current
      )
      
      # Listing is optional, so this should be valid
      # But in practice, we'd want listing at creation
      expect(purchase).to be_valid
    end

    it 'requires a price' do
      purchase = Purchase.new(
        buyer: buyer,
        listing: listing,
        purchased_at: Time.current
      )
      
      expect(purchase).not_to be_valid
      expect(purchase.errors[:price]).to be_present
    end

    it 'requires purchased_at' do
      purchase = Purchase.new(
        buyer: buyer,
        listing: listing,
        price: 50.00
      )
      
      expect(purchase).not_to be_valid
      expect(purchase.errors[:purchased_at]).to be_present
    end
  end

  describe 'scopes' do
    let(:buyer) { User.create!(email: 'buyer@test.com', password: 'password123') }
    let(:seller) { User.create!(email: 'seller@test.com', password: 'password123') }

    it 'returns empty collection when buyer has no purchases' do
      expect(buyer.purchases).to be_empty
    end

    it 'orders by purchased_at descending' do
      older = Purchase.create!(
        buyer: buyer,
        listing: Listing.create!(title: 'Old', price: 10.00, user: seller),
        price: 10.00,
        purchased_at: 2.days.ago
      )
      
      newer = Purchase.create!(
        buyer: buyer,
        listing: Listing.create!(title: 'New', price: 20.00, user: seller),
        price: 20.00,
        purchased_at: 1.day.ago
      )

      purchases = buyer.purchases.order(purchased_at: :desc)
      expect(purchases.first).to eq(newer)
      expect(purchases.last).to eq(older)
    end
  end

  describe 'listing title' do
    let(:buyer) { User.create!(email: 'buyer@test.com', password: 'password123') }
    let(:seller) { User.create!(email: 'seller@test.com', password: 'password123') }
    let(:listing) { Listing.create!(title: 'Test Item', price: 50.00, user: seller) }
    let(:purchase) do
      Purchase.create!(
        buyer: buyer,
        listing: listing,
        price: 50.00,
        purchased_at: Time.current
      )
    end

    it 'returns listing title when listing exists' do
      expect(purchase.listing_title).to eq('Test Item')
    end

    it 'returns fallback message when listing is deleted' do
      listing.destroy
      purchase.reload
      expect(purchase.listing_title).to eq('Listing no longer available')
    end
  end
end