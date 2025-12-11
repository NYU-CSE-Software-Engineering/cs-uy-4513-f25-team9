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

  describe 'GET /moderations/user_list' do
    context 'when user is a moderator' do
      let(:moderator) { User.create!(email: 'mod@example.com', password: 'password123', is_moderator: true) }
      let!(:user1) { User.create!(email: 'user1@example.com', password: 'password123') }
      let!(:user2) { User.create!(email: 'user2@example.com', password: 'password123') }

      before { stub_current_user(moderator) }

      it 'allows access to user list page' do
        get '/moderations/user_list'
        expect(response).to have_http_status(:ok)
      end

      it 'displays all users' do
        get '/moderations/user_list'
        expect(response.body).to include('user1@example.com')
        expect(response.body).to include('user2@example.com')
      end
    end

    context 'when user is not a moderator' do
      let(:regular_user) { User.create!(email: 'user@example.com', password: 'password123') }

      before { stub_current_user(regular_user) }

      it 'redirects to root path' do
        get '/moderations/user_list'
        expect(response).to redirect_to(root_path)
      end

      it 'shows permission denied message' do
        get '/moderations/user_list'
        follow_redirect!
        expect(response.body).to match(/You don.*t have permission to access this page/)
      end
    end

    context 'when user is not logged in' do
      before { stub_current_user(nil) }

      it 'redirects to root path' do
        get '/moderations/user_list'
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'DELETE /moderations/users/:id' do
    context 'when admin deletes a regular user' do
      let(:admin) { User.create!(email: 'admin@example.com', password: 'password123', is_moderator: true, is_admin: true) }
      let(:target_user) { User.create!(email: 'target@example.com', password: 'password123') }

      before { stub_current_user(admin) }

      it 'successfully deletes the user' do
        delete "/moderations/users/#{target_user.id}"
        expect(User.find_by(id: target_user.id)).to be_nil
      end

      it 'redirects to moderations path' do
        delete "/moderations/users/#{target_user.id}"
        expect(response).to redirect_to(moderations_path)
      end

      it 'shows success message with user name and ID' do
        user_name = target_user.name
        user_id = target_user.id
        delete "/moderations/users/#{target_user.id}"
        follow_redirect!
        expect(response.body).to include("User #{user_name} with ID #{user_id} has been deleted")
      end
    end

    context 'when admin deletes a moderator' do
      let(:admin) { User.create!(email: 'admin@example.com', password: 'password123', is_moderator: true, is_admin: true) }
      let(:target_moderator) { User.create!(email: 'mod@example.com', password: 'password123', is_moderator: true) }

      before { stub_current_user(admin) }

      it 'successfully deletes the moderator' do
        delete "/moderations/users/#{target_moderator.id}"
        expect(User.find_by(id: target_moderator.id)).to be_nil
      end
    end

    context 'when moderator tries to delete another moderator' do
      let(:moderator) { User.create!(email: 'mod1@example.com', password: 'password123', is_moderator: true) }
      let(:target_moderator) { User.create!(email: 'mod2@example.com', password: 'password123', is_moderator: true) }

      before { stub_current_user(moderator) }

      it 'does not delete the user' do
        delete "/moderations/users/#{target_moderator.id}"
        expect(User.find_by(id: target_moderator.id)).not_to be_nil
      end

      it 'redirects to moderations path' do
        delete "/moderations/users/#{target_moderator.id}"
        expect(response).to redirect_to(moderations_path)
      end

      it 'shows permission denied message' do
        delete "/moderations/users/#{target_moderator.id}"
        follow_redirect!
        expect(response.body).to match(/You don.*t have permission to delete User with ID #{target_moderator.id}/)
      end
    end

    context 'when user tries to delete themselves' do
      let(:moderator) { User.create!(email: 'mod@example.com', password: 'password123', is_moderator: true) }

      before { stub_current_user(moderator) }

      it 'does not delete the user' do
        delete "/moderations/users/#{moderator.id}"
        expect(User.find_by(id: moderator.id)).not_to be_nil
      end

      it 'redirects to moderations path' do
        delete "/moderations/users/#{moderator.id}"
        expect(response).to redirect_to(moderations_path)
      end

      it 'shows error message' do
        delete "/moderations/users/#{moderator.id}"
        follow_redirect!
        expect(response.body).to include('You cannot delete yourself')
      end
    end

    context 'when trying to delete non-existent user' do
      let(:admin) { User.create!(email: 'admin@example.com', password: 'password123', is_moderator: true, is_admin: true) }

      before { stub_current_user(admin) }

      it 'shows error message' do
        delete '/moderations/users/999'
        follow_redirect!
        expect(response.body).to include('User does not exist')
      end

      it 'redirects to moderations path' do
        delete '/moderations/users/999'
        expect(response).to redirect_to(moderations_path)
      end
    end

    context 'when regular user tries to delete' do
      let(:regular_user) { User.create!(email: 'user@example.com', password: 'password123') }
      let(:target_user) { User.create!(email: 'target@example.com', password: 'password123') }

      before { stub_current_user(regular_user) }

      it 'redirects to root path' do
        delete "/moderations/users/#{target_user.id}"
        expect(response).to redirect_to(root_path)
      end

      it 'does not delete the user' do
        delete "/moderations/users/#{target_user.id}"
        expect(User.find_by(id: target_user.id)).not_to be_nil
      end
    end
  end

  describe 'PATCH /moderations/users/:id/remove_moderator' do
    context 'when admin removes moderator privileges' do
      let(:admin) { User.create!(email: 'admin@example.com', password: 'password123', is_moderator: true, is_admin: true) }
      let(:moderator) { User.create!(email: 'mod@example.com', password: 'password123', is_moderator: true) }

      before { stub_current_user(admin) }

      it 'successfully removes moderator privileges' do
        patch "/moderations/users/#{moderator.id}/remove_moderator"
        moderator.reload
        expect(moderator.is_moderator).to be false
      end

      it 'redirects to moderations path' do
        patch "/moderations/users/#{moderator.id}/remove_moderator"
        expect(response).to redirect_to(moderations_path)
      end

      it 'shows success message' do
        moderator_name = moderator.name
        patch "/moderations/users/#{moderator.id}/remove_moderator"
        follow_redirect!
        expect(response.body).to include("Moderator privileges removed from #{moderator_name}")
      end
    end

    context 'when trying to remove privileges from non-moderator' do
      let(:admin) { User.create!(email: 'admin@example.com', password: 'password123', is_moderator: true, is_admin: true) }
      let(:regular_user) { User.create!(email: 'user@example.com', password: 'password123') }

      before { stub_current_user(admin) }

      it 'shows error message' do
        patch "/moderations/users/#{regular_user.id}/remove_moderator"
        follow_redirect!
        expect(response.body).to include("User #{regular_user.name} is not a moderator")
      end

      it 'redirects to moderations path' do
        patch "/moderations/users/#{regular_user.id}/remove_moderator"
        expect(response).to redirect_to(moderations_path)
      end
    end

    context 'when trying to remove admin privileges' do
      let(:admin1) { User.create!(email: 'admin1@example.com', password: 'password123', is_moderator: true, is_admin: true) }
      let(:admin2) { User.create!(email: 'admin2@example.com', password: 'password123', is_moderator: true, is_admin: true) }

      before { stub_current_user(admin1) }

      it 'shows error message' do
        patch "/moderations/users/#{admin2.id}/remove_moderator"
        follow_redirect!
        expect(response.body).to include('Cannot remove admin privileges through this action')
      end

      it 'redirects to moderations path' do
        patch "/moderations/users/#{admin2.id}/remove_moderator"
        expect(response).to redirect_to(moderations_path)
      end

      it 'does not remove moderator status' do
        patch "/moderations/users/#{admin2.id}/remove_moderator"
        admin2.reload
        expect(admin2.is_moderator).to be true
      end
    end

    context 'when trying to remove from non-existent user' do
      let(:admin) { User.create!(email: 'admin@example.com', password: 'password123', is_moderator: true, is_admin: true) }

      before { stub_current_user(admin) }

      it 'shows error message' do
        patch '/moderations/users/999/remove_moderator'
        follow_redirect!
        expect(response.body).to include('User does not exist')
      end

      it 'redirects to moderations path' do
        patch '/moderations/users/999/remove_moderator'
        expect(response).to redirect_to(moderations_path)
      end
    end

    context 'when non-admin tries to remove moderator' do
      let(:moderator) { User.create!(email: 'mod@example.com', password: 'password123', is_moderator: true) }
      let(:target_moderator) { User.create!(email: 'mod2@example.com', password: 'password123', is_moderator: true) }

      before { stub_current_user(moderator) }

      it 'shows error message' do
        patch "/moderations/users/#{target_moderator.id}/remove_moderator"
        follow_redirect!
        expect(response.body).to include('Only admins can perform this action')
      end

      it 'redirects to moderations path' do
        patch "/moderations/users/#{target_moderator.id}/remove_moderator"
        expect(response).to redirect_to(moderations_path)
      end

      it 'does not remove moderator status' do
        patch "/moderations/users/#{target_moderator.id}/remove_moderator"
        target_moderator.reload
        expect(target_moderator.is_moderator).to be true
      end
    end

    context 'when regular user tries to remove moderator' do
      let(:regular_user) { User.create!(email: 'user@example.com', password: 'password123') }
      let(:moderator) { User.create!(email: 'mod@example.com', password: 'password123', is_moderator: true) }

      before { stub_current_user(regular_user) }

      it 'redirects to root path' do
        patch "/moderations/users/#{moderator.id}/remove_moderator"
        expect(response).to redirect_to(root_path)
      end

      it 'does not remove moderator status' do
        patch "/moderations/users/#{moderator.id}/remove_moderator"
        moderator.reload
        expect(moderator.is_moderator).to be true
      end
    end
  end
end

