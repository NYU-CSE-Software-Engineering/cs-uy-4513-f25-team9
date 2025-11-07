require 'rails_helper'

RSpec.describe 'Purchase History', type: :request do
  def stub_current_user(user)
    allow_any_instance_of(PurchasesController).to receive(:current_user).and_return(user)
  end

  describe 'GET /purchases' do
    context 'when the buyer has past purchases' do
      let(:buyer)  { User.create!(email: 'buyer@example.com', password: 'password123') }
      let(:seller) { User.create!(email: 'seller@example.com', password: 'password123') }

      let!(:older_listing) { Listing.create!(title: 'Old Item',  price: 10.00, user: seller) }
      let!(:newer_listing) { Listing.create!(title: 'New Item',  price: 20.00, user: seller) }

      let!(:older_purchase) do
        Purchase.create!(buyer: buyer, listing: older_listing, price: 10.00, purchased_at: 2.days.ago)
      end

      let!(:newer_purchase) do
        Purchase.create!(buyer: buyer, listing: newer_listing, price: 20.00, purchased_at: 1.day.ago)
      end

      before { stub_current_user(buyer) }

      it 'responds successfully' do
        get '/purchases'
        expect(response).to have_http_status(:ok)
      end

      it 'shows the purchased items with most recent first' do
        get '/purchases'

        body = response.body
        # Should include titles and show the newer purchase before the older one
        expect(body).to include('New Item')
        expect(body).to include('Old Item')

        expect(body.index('New Item')).to be < body.index('Old Item')
      end

      it 'shows final price and sold date for each item' do
        get '/purchases'

        expect(response.body).to include('20.00')
        expect(response.body).to include('10.00')

        # Loosely check that purchased_at is rendered in some form
        expect(response.body).to include(newer_purchase.purchased_at.to_date.to_s)
        expect(response.body).to include(older_purchase.purchased_at.to_date.to_s)
      end
    end

    context 'when the buyer has no purchases' do
      let(:buyer) { User.create!(email: 'newbuyer@example.com', password: 'password123') }

      before { stub_current_user(buyer) }

      it 'shows a friendly empty state message' do
        get '/purchases'
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('No purchases yet')
      end
    end
  end
end
