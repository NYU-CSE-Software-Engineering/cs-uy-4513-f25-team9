require 'rails_helper'

RSpec.feature "Report Listing", type: :feature do
  let(:user) { User.create!(email: 'test@example.com', password: 'password') }
  let(:seller) { User.create!(email: 'seller@example.com', password: 'password') }
  let(:listing) { Listing.create!(title: 'Suspicious Item', description: 'Looks fake', price: 999, user: seller) }

  scenario "User successfully reports a listing" do
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: 'password'
    click_button "Log in"

    # Navigate to listing and report it
    visit listing_path(listing)
    click_link "Report listing"

    # Fill out report form
    expect(page).to have_content("Report This Listing")
    fill_in "Reason", with: "This listing appears to be fraudulent"
    click_button "Submit Report"

    # Verify success
    expect(page).to have_content("Thanks—our moderators will review this")
    expect(page).to have_current_path(listing_path(listing))

    # Verify report was created
    expect(Report.count).to eq(1)
    report = Report.last
    expect(report.user).to eq(user)
    expect(report.listing).to eq(listing)
    expect(report.reason).to include("fraudulent")
  end

  scenario "User cannot report when not logged in" do
    visit listing_path(listing)
    click_link "Report listing"

    # Redirect to login
    expect(page).to have_current_path(login_path)
    expect(page).to have_content("Please sign in")
  end

  scenario "User cannot submit report with empty reason" do
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: 'password'
    click_button "Log in"

    # Try to submit with empty reason
    visit new_listing_report_path(listing)
    fill_in "Reason", with: ""
    click_button "Submit Report"

    # Should see validation error for empty reason
    expect(Report.count).to eq(0)
    # Form should still be visible (validation failed)
    expect(page).to have_content("Report This Listing")
    expect(page).to have_button("Submit Report")
  end
end