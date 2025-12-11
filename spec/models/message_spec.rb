require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:buyer) { User.create!(email: 'buyer@example.com', password: 'password') }
  let(:seller) { User.create!(email: 'seller@example.com', password: 'password') }
  let(:listing) { Listing.create!(title: 'Test Item', description: 'Test', price: 100, user: seller) }
  let(:conversation) { Conversation.create!(buyer: buyer, seller: seller, listing: listing) }

  describe 'validations' do
    it 'requires content' do
      message = Message.new(content: nil, user: buyer, conversation: conversation)
      expect(message).to be_invalid
    end

    it 'requires a user' do
      message = Message.new(content: 'Test message', user: nil, conversation: conversation)
      expect(message).to be_invalid
    end

    it 'requires a conversation' do
      message = Message.new(content: 'Test message', user: buyer, conversation: nil)
      expect(message).to be_invalid
    end

    it 'validates content is not empty' do
      message = Message.new(content: '', user: buyer, conversation: conversation)
      expect(message).to be_invalid
    end
  end

  describe 'associations' do
    it 'belongs to a user' do
      message = Message.reflect_on_association(:user)
      expect(message.macro).to eq(:belongs_to)
    end

    it 'belongs to a conversation' do
      message = Message.reflect_on_association(:conversation)
      expect(message.macro).to eq(:belongs_to)
    end
  end

  describe 'default values' do
    it 'sets read to false by default' do
      message = Message.create!(content: 'Test message', user: buyer, conversation: conversation)
      expect(message.read).to be false
    end
  end
end
