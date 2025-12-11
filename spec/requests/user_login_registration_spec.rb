require 'rails_helper'
require 'cgi'

RSpec.describe "User Login and Registration", type: :request do
  describe "GET /users/new" do
    it "renders the sign up page" do
      get '/users/new'
      expect(response).to have_http_status(:ok)
    end
  end
end

RSpec.describe "User Sign Up (mismatch)", type: :request do
  require 'cgi'

  describe "POST /users (registration)" do
    context "when password confirmation does not match" do
      it "does not create the user and shows a validation message and stays on signup" do
        expect {
          post '/users', params: { user: { email: 'mismatch@example.com', password: 'password123', password_confirmation: 'different' } }
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_content)
        expect(CGI.unescapeHTML(response.body)).to include("Password confirmation doesn't match Password.")

        actual_path = response.request.fullpath
        expect(['/users/new', '/users']).to include(actual_path)
      end
    end
  end
end

RSpec.describe "Logout link in layout", type: :request do
  describe "Layout when user is signed in" do
    it "shows a Log Out link in the profile dropdown when current_user is present" do
      user = User.create!(email: 'logout@example.com', password: 'password123', password_confirmation: 'password123')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      get '/'
      expect(response).to have_http_status(:ok)
      body = CGI.unescapeHTML(response.body)
      expect(body).to include('Log Out')
      expect(body).to include('profileDropdownMenu')
    end
  end
end


RSpec.describe SessionsController, type: :controller do
  describe "DELETE #destroy" do
    let(:user) { User.create!(email: "test@example.com", password: "password123") }

    before do
      # simulate login
      session[:user_id] = user.id
    end

    it "clears the session" do
      delete :destroy
      expect(session[:user_id]).to be_nil
    end

    it "redirects to the home page" do
      delete :destroy
      expect(response).to redirect_to(root_path)
    end

    it "sets a Logged out notice" do
      delete :destroy
      expect(flash[:notice]).to eq("Logged out")
    end
  end
end

