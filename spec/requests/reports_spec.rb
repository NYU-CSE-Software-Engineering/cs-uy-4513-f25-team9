require 'rails_helper'

RSpec.describe "Reports", type: :request do
  let(:user) { User.create!(email: 'buyer@example.com') }
  let(:listing) { Listing.create!(title: 'Test listing', price: 10.0, user: user) }

  describe "GET /listings/:id/reports/new" do
    it "renders the new template" do
      get new_listing_report_path(listing)

      expect(response).to be_successful
      # `render_template` matcher requires the `rails-controller-testing` gem in request specs;
      # assert the rendered content instead.
      expect(response.body).to include("Report Listing")
    end
  end
end