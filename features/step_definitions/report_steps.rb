# features/step_definitions/report_steps.rb

Given('I am logged in as a buyer') do
  @buyer = User.create!(email: 'buyer@example.com', password: 'password123')
  visit login_path
  fill_in "Email", with: @buyer.email
  fill_in "Password", with: "password123"
  click_button "Log in"
end

Given('I am viewing a listing that I believe is fraudulent') do
  # @listing = Listing.create!(title: "Scam", description: "Fake", price: 999, user: User.create!(email: 'seller@example.com', password: 'pw123456'))
  pending
end

When('I click "Report listing"') do
  # visit new_listing_report_path(@listing)
  pending
end

When('I select a reason and submit the report') do
  # fill_in "Reason", with: "This looks fraudulent"
  # click_button "Submit Report"
  pending
end 

Then('a report should be recorded for that listing and my account') do
  # expect(Report.where(user: @buyer, listing: @listing).exists?).to be true
  pending
end

Then('I should see {string}') do |text|
  # expect(page).to have_content(text)
  pending
end

Given('I am not logged in') do
  # visit logout_path rescue nil
  pending
end

When('I attempt to submit a report for a listing') do
  # seller = User.create!(email: 'seller2@example.com', password: 'pw123456')
  # @listing = Listing.create!(title: "Fake watch", description: "Looks sketchy", price: 50, user: seller)
  # visit new_listing_report_path(@listing)
  pending
end

Then('I should be redirected to the login page') do
  # expect(page).to have_current_path(login_path)
  pending
end
