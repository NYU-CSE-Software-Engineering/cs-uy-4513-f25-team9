# features/step_definitions/report_steps.rb

Given('I am logged in as a buyer') do

  @buyer = User.create!(email: 'buyer@example.com')

end

Given('I am viewing a listing that I believe is fraudulent') do

  @listing = Listing.create!(title: "Scam", price: 999, user_id: User.first.id)
end

When('I click "Report listing"') do
  visit new_listing_report_path(@listing)
end

# --- (pending) ---

When('I select a reason and submit the report') do
  pending 
end

Then('a flag should be recorded for that listing and my account') do
  pending 
end

Then('I should see {string}') do |string|
  pending
end