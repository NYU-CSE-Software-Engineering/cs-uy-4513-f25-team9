require 'rails_helper'

RSpec.describe 'Moderations', type: :request do
  def stub_current_user(user)
    allow_any_instance_of(ModerationsController).to receive(:current_user).and_return(user)
  end

  describe 'GET /moderations/reported_listings' do
    context 'when user is a moderator' do
      let(:moderator) { User.create!(email: 'mod@example.com', password: 'password123', is_moderator: true) }
      let(:seller) { User.create!(email: 'seller@example.com', password: 'password123') }
      let(:reporter) { User.create!(email: 'reporter@example.com', password: 'password123') }
      let!(:listing1) { Listing.create!(user: seller, title: 'Reported Product 1', price: 50.00) }
      let!(:listing2) { Listing.create!(user: seller, title: 'Reported Product 2', price: 75.00) }
      let!(:report1) { Report.create!(user: reporter, listing: listing1, reason: 'Suspicious pricing') }
      let!(:report2) { Report.create!(user: reporter, listing: listing2, reason: 'Fake product') }

      before { stub_current_user(moderator) }

      it 'allows access to reported listings page' do
        get '/moderations/reported_listings'
        expect(response).to have_http_status(:ok)
      end

      it 'displays all reported listings' do
        get '/moderations/reported_listings'
        expect(response.body).to include('Reported Product 1')
        expect(response.body).to include('Reported Product 2')
      end

      it 'displays report reasons' do
        get '/moderations/reported_listings'
        expect(response.body).to include('Suspicious pricing')
        expect(response.body).to include('Fake product')
      end
    end

    context 'when user is not a moderator' do
      let(:regular_user) { User.create!(email: 'user@example.com', password: 'password123') }

      before { stub_current_user(regular_user) }

      it 'redirects to root path' do
        get '/moderations/reported_listings'
        expect(response).to redirect_to(root_path)
      end

      it 'shows permission denied message' do
        get '/moderations/reported_listings'
        follow_redirect!
        expect(response.body).to match(/You don.*t have permission to access this page/)
      end
    end

    context 'when user is not logged in' do
      before { stub_current_user(nil) }

      it 'redirects to root path' do
        get '/moderations/reported_listings'
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when there are no reported listings' do
      let(:moderator) { User.create!(email: 'mod@example.com', password: 'password123', is_moderator: true) }

      before { stub_current_user(moderator) }

      it 'shows empty state message' do
        get '/moderations/reported_listings'
        expect(response.body).to include('No reported listings pending review')
      end
    end
  end

  describe 'DELETE /moderations/listings/:id' do
    context 'when moderator deletes a reported listing' do
      let(:moderator) { User.create!(email: 'mod@example.com', password: 'password123', is_moderator: true) }
      let(:seller) { User.create!(email: 'seller@example.com', password: 'password123') }
      let(:reporter) { User.create!(email: 'reporter@example.com', password: 'password123') }
      let!(:listing) { Listing.create!(user: seller, title: 'Fake Product', price: 100.00) }
      let!(:report) { Report.create!(user: reporter, listing: listing, reason: 'Fraudulent listing') }

      before { stub_current_user(moderator) }

      it 'successfully deletes the listing' do
        delete "/moderations/listings/#{listing.id}"
        expect(Listing.find_by(id: listing.id)).to be_nil
      end

      it 'redirects to reported listings page' do
        delete "/moderations/listings/#{listing.id}"
        expect(response).to redirect_to('/moderations/reported_listings')
      end

      it 'shows success message with listing title and ID' do
        delete "/moderations/listings/#{listing.id}"
        follow_redirect!
        expect(response.body).to include("Listing Fake Product with ID #{listing.id} has been removed")
      end
    end

    context 'when trying to delete non-existent listing' do
      let(:moderator) { User.create!(email: 'mod@example.com', password: 'password123', is_moderator: true) }

      before { stub_current_user(moderator) }

      it 'shows error message' do
        delete '/moderations/listings/999'
        follow_redirect!
        expect(response.body).to include('Listing does not exist')
      end

      it 'redirects to reported listings page' do
        delete '/moderations/listings/999'
        expect(response).to redirect_to('/moderations/reported_listings')
      end
    end

    context 'when regular user tries to delete' do
      let(:regular_user) { User.create!(email: 'user@example.com', password: 'password123') }
      let(:seller) { User.create!(email: 'seller@example.com', password: 'password123') }
      let!(:listing) { Listing.create!(user: seller, title: 'Product', price: 50.00) }

      before { stub_current_user(regular_user) }

      it 'redirects to root path' do
        delete "/moderations/listings/#{listing.id}"
        expect(response).to redirect_to(root_path)
      end
    end
  end
end

