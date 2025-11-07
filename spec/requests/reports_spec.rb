require 'rails_helper'

RSpec.describe "Reports", type: :request do
  let(:user) { User.create!(email: 'buyer@example.com', password: 'password123') }
  let(:listing) { Listing.create!(title: 'Scam Item', price: 100, user: user) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "GET /listings/:listing_id/reports/new" do
    it "renders the new template" do
      get new_listing_report_path(listing)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /listings/:listing_id/reports" do
    it "creates a new report" do
      expect {
        post listing_reports_path(listing), params: {
          report: { reason: "Fraudulent" }
        }
      }.to change(Report, :count).by(1)
      expect(response).to redirect_to(listing_path(listing))
    end
  end
end
