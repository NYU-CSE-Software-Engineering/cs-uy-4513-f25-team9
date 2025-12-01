require 'rails_helper'

RSpec.describe "Conversations", type: :request do
  let(:user) { User.create!(email: 'user@example.com', password: 'password') }
  let(:other_user) { User.create!(email: 'other@example.com', password: 'password') }
  let(:listing) { Listing.create!(title: 'Test Item', description: 'Test', price: 100, user: other_user) }

  before do
    sign_in user
  end

  describe "GET /new" do
    it "renders the new conversation form" do
      get new_listing_conversation_path(listing_id: listing.id)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    it "creates a new conversation and redirects" do
      expect {
        post listing_conversations_path(listing_id: listing.id)
      }.to change(Conversation, :count).by(1)
      expect(response).to redirect_to(conversation_path(Conversation.last))
    end
  end

  describe "GET /show" do
    it "shows a conversation" do
      conversation = Conversation.create!(buyer: user, seller: other_user, listing: listing)
      get conversation_path(conversation)
      expect(response).to have_http_status(:success)
    end
  end
end