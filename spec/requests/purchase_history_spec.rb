require 'rails_helper'

RSpec.describe 'Purchase History', type: :request do
  def stub_current_user(user)
    allow_any_instance_of(PurchasesController).to receive(:current_user).and_return(user)
  end

  describe 'GET /purchases' do
    context 'when user is not authenticated' do
      it 'redirects to login page' do
        get '/purchases'
        expect(response).to redirect_to('/login')
      end
    end

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

      it 'only shows purchases for the current user' do
        other_buyer = User.create!(email: 'other@example.com', password: 'password123')
        other_purchase = Purchase.create!(
          buyer: other_buyer,
          listing: Listing.create!(title: 'Other Item', price: 100.00, user: seller),
          price: 100.00,
          purchased_at: 1.day.ago
        )

        get '/purchases'
        expect(response.body).not_to include('Other Item')
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

    context 'when purchase has deleted listing' do
      let(:buyer)  { User.create!(email: 'buyer@example.com', password: 'password123') }
      let(:seller) { User.create!(email: 'seller@example.com', password: 'password123') }
      let(:listing) { Listing.create!(title: 'Deleted Item', price: 50.00, user: seller) }
      let!(:purchase) do
        Purchase.create!(buyer: buyer, listing: listing, price: 50.00, purchased_at: 1.day.ago)
      end

      before do
        # Simulate deleted listing by setting listing_id to nil
        # This simulates what happens when listing is deleted with on_delete: :nullify
        purchase.update_column(:listing_id, nil)
        stub_current_user(buyer)
      end

      it 'still shows the purchase' do
        get '/purchases'
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('50.00')
      end

      it 'shows a message for deleted listing' do
        get '/purchases'
        expect(response.body).to include('Listing no longer available')
      end
    end

    context 'when multiple purchases on same day' do
      let(:buyer)  { User.create!(email: 'buyer@example.com', password: 'password123') }
      let(:seller) { User.create!(email: 'seller@example.com', password: 'password123') }
      let(:same_day) { 2.days.ago.beginning_of_day }

      let!(:first_purchase) do
        Purchase.create!(
          buyer: buyer,
          listing: Listing.create!(title: 'First Item', price: 10.00, user: seller),
          price: 10.00,
          purchased_at: same_day + 2.hours
        )
      end

      let!(:second_purchase) do
        Purchase.create!(
          buyer: buyer,
          listing: Listing.create!(title: 'Second Item', price: 20.00, user: seller),
          price: 20.00,
          purchased_at: same_day + 4.hours
        )
      end

      let!(:third_purchase) do
        Purchase.create!(
          buyer: buyer,
          listing: Listing.create!(title: 'Third Item', price: 30.00, user: seller),
          price: 30.00,
          purchased_at: same_day + 6.hours
        )
      end

      before { stub_current_user(buyer) }

      it 'shows all purchases from that day' do
        get '/purchases'
        expect(response.body).to include('First Item')
        expect(response.body).to include('Second Item')
        expect(response.body).to include('Third Item')
      end

      it 'orders them by purchased_at time' do
        get '/purchases'
        body = response.body
        expect(body.index('Third Item')).to be < body.index('Second Item')
        expect(body.index('Second Item')).to be < body.index('First Item')
      end
    end
  end
ends