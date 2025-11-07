# features/step_definitions/report_steps.rb

Given('I am logged in as a buyer') do
  @buyer = User.create!(email: 'buyer@example.com', password: 'password123')
  visit login_path
  fill_in "Email", with: @buyer.email
  fill_in "Password", with: "password123"
  click_button "Log in"
end

Given('I am viewing a listing that I believe is fraudulent') do
  @seller = User.create!(email: 'seller@example.com', password: 'password123')
  @listing = Listing.create!(title: "Scam", description: "Fake", price: 999, user: @seller)
  visit listing_path(@listing)
end

When('I click "Report listing"') do
  click_link "Report listing"
end

When('I select a reason and submit the report') do
  fill_in "Reason", with: "This looks fraudulent"
  click_button "Submit Report"
end 

Then('a report should be recorded for that listing and my account') do
  expect(Report.where(user: @buyer, listing: @listing).exists?).to be true
end

Given('I am not logged in') do
  # Clear the session to ensure no user is logged in
  Capybara.reset_session!
end

When('I attempt to submit a report for a listing') do
  seller = User.create!(email: 'seller2@example.com', password: 'password123')
  @listing = Listing.create!(title: "Fake watch", description: "Looks sketchy", price: 50, user: seller)
  visit new_listing_report_path(@listing)
end

Then('I should be redirected to the login page') do
  expect(page).to have_current_path(login_path)
end

Then('I should see {string}') do |text|
  expect(page).to have_content(text)
end