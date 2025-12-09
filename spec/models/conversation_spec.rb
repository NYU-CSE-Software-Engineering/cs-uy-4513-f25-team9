require 'rails_helper'

RSpec.describe Conversation, type: :model do
  let(:buyer) { User.create!(email: 'buyer@example.com', password: 'password') }
  let(:seller) { User.create!(email: 'seller@example.com', password: 'password') }
  let(:listing) { Listing.create!(title: 'Test Item', description: 'Test', price: 100, user: seller) }

  describe 'validations' do
    it 'requires a buyer' do
      conversation = Conversation.new(buyer: nil, seller: seller, listing: listing)
      expect(conversation).to be_invalid
    end

    it 'requires a seller' do
      conversation = Conversation.new(buyer: buyer, seller: nil, listing: listing)
      expect(conversation).to be_invalid
    end

    it 'requires a listing' do
      conversation = Conversation.new(buyer: buyer, seller: seller, listing: nil)
      expect(conversation).to be_invalid
    end
  end

  describe 'associations' do
    it 'belongs to a buyer' do
      conversation = Conversation.reflect_on_association(:buyer)
      expect(conversation.macro).to eq(:belongs_to)
    end

    it 'belongs to a seller' do
      conversation = Conversation.reflect_on_association(:seller)
      expect(conversation.macro).to eq(:belongs_to)
    end

    it 'belongs to a listing' do
      conversation = Conversation.reflect_on_association(:listing)
      expect(conversation.macro).to eq(:belongs_to)
    end

    it 'has many messages' do
      conversation = Conversation.reflect_on_association(:messages)
      expect(conversation.macro).to eq(:has_many)
    end
  end
end
