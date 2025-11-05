require 'rails_helper'

RSpec.describe "Reports", type: :request do
  let(:user) { User.create!(email: 'buyer@example.com') }
  let(:listing) { Listing.create!(title: 'Test listing', price: 10.0, user: user) }
  # ---------------------------

  describe "GET /listings/:id/reports/new" do
    it "renders the new template" do
      get new_listing_report_path(listing)
      expect(response).to be_successful
      expect(response.body).to include("Report Listing")
    end
  end

  describe "POST /listings/:id/reports" do
    it "creates a new report" do
      report_attributes = { reason: "This is a test report." }


      expect {
        post listing_reports_path(listing), params: { report: report_attributes }
      }.to change(Report, :count).by(1)

      expect(response).to redirect_to(listing_path(listing))
    end
  end
  # ---------------------------------
end