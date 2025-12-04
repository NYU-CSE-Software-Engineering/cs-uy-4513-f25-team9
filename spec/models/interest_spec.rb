require 'rails_helper'

RSpec.describe Interest, type: :model do
  let(:buyer)   { User.create!(email: 'buyer@example.com', password: 'password123') }
  let(:seller)  { User.create!(email: 'seller@example.com', password: 'password123') }
  let(:listing) { Listing.create!(title: 'Test Item', description: 'Nice', price: 10, user: seller) }

  describe 'associations' do
    it 'belongs to a buyer (User)' do
      association = described_class.reflect_on_association(:buyer)
      expect(association.macro).to eq(:belongs_to)
      expect(association.options[:class_name]).to eq('User')
    end

    it 'belongs to a listing' do
      association = described_class.reflect_on_association(:listing)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    it 'requires buyer, listing, and state' do
      interest = described_class.new
      interest.validate
      expect(interest.errors[:buyer]).to include("must exist")
      expect(interest.errors[:listing]).to include("must exist")
      expect(interest.errors[:state]).to include("can't be blank")
    end

    it 'enforces unique buyer/listing pair' do
      described_class.create!(buyer:, listing:, state: 'liked')
      duplicate = described_class.new(buyer:, listing:, state: 'passed')
      duplicate.validate
      expect(duplicate.errors[:buyer_id]).to include("has already been taken")
    end

    it 'accepts only allowed states' do
      interest = described_class.new(buyer:, listing:, state: 'invalid')
      expect(interest).to be_invalid
    end
  end

  describe 'enums' do
    it 'defines liked and passed states' do
      interest = described_class.create!(buyer:, listing:, state: 'liked')
      expect(interest.state).to eq('liked')
      interest.state = 'passed'
      expect(interest.state).to eq('passed')
    end
  end
end
