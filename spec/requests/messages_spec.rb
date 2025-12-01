require 'rails_helper'

RSpec.describe "Messages", type: :request do
  let(:user) { User.create!(email: 'user@example.com', password: 'password') }
  let(:other_user) { User.create!(email: 'other@example.com', password: 'password') }
  let(:listing) { Listing.create!(title: 'Test Item', description: 'Test', price: 100, user: other_user) }
  let(:conversation) { Conversation.create!(buyer: user, seller: other_user, listing: listing) }

  before do
    post login_path, params: { email: user.email, password: 'password' }
  end

  describe "POST /create" do
    it "creates a new message in the conversation" do
      expect {
        post conversation_messages_path(conversation_id: conversation.id), params: {
          message: { content: "Hello, is this available?" }
        }
      }.to change(Message, :count).by(1)
      expect(response).to redirect_to(conversation_path(conversation))
    end

    it "does not create message with empty content" do
      expect {
        post conversation_messages_path(conversation_id: conversation.id), params: {
          message: { content: "" }
        }
      }.not_to change(Message, :count)
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end