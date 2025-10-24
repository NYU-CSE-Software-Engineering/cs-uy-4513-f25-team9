require 'capybara/cucumber'
require 'rails/test_help'

# Step: Moderator logs in
Given("I am a signed-in Moderator") do
  # Create a test Moderator user
  @moderator = User.create!(
    email: 'moderator_test@thryft.com',
    password: 'password123',
    name: 'Test Moderator'
  )
  # Assign Moderator role (assuming 'moderator' role exists in the role table)
  moderator_role = Role.find_by(name: 'moderator')
  UserRole.create!(user: @moderator, role: moderator_role)

  # Simulate login
  visit new_user_session_path
  fill_in 'Email', with: @moderator.email
  fill_in 'Password', with: 'password123'
  click_button 'Log in'
end

# Step: Create a test reported listing
Given("there is a reported listing with ID {string} and name {string}") do |listing_id, name|
  # Create a product listing
  @listing = Listing.create!(
    id: listing_id,
    name: name,
    price: 99.99,
    is_deleted: false
  )
  # Create a corresponding report record
  Flag.create!(
    listing_id: listing_id,
    report_reason: 'This is a fake product',
    processed: false
  )
end

# Step: Access the reported listings page
Given("I am on the reported listings page") do
  visit moderations_reported_listings_path
end

# Step: Click the delete button
When("I click the {string} button for listing ID {string}") do |button_text, listing_id|
  within("tr:has(td:contains('#{Listing.find(listing_id).name}'))") do
    click_button button_text
  end
end

# Step: Verify success message
Then("I should see the message {string}") do |message|
  expect(page).to have_content(message)
end

# Step: Verify product is marked as deleted in the database
Then("the listing with ID {string} should be marked as deleted in the database") do |listing_id|
  listing = Listing.find(listing_id)
  expect(listing.is_deleted).to be true
end

# Step: Submit delete request for non-existent listing
When("I submit a delete request for listing ID {string} (non-existent)") do |listing_id|
  # Manually construct form submission to simulate deleting a non-existent product
  visit moderations_reported_listings_path
  page.driver.post(
    moderations_confirm_remove_path,
    { listing_id: listing_id }
  )
  follow_redirect!
end

# Step: Verify error message
Then("I should see the error message {string}") do |error_message|
  expect(flash[:error]).to eq(error_message)
end

# Step: Buyer logs in
Given("I am a signed-in Buyer") do
  # Create a test Buyer user
  @buyer = User.create!(
    email: 'buyer_test@thryft.com',
    password: 'password123',
    name: 'Test Buyer'
  )
  # Assign Buyer role
  buyer_role = Role.find_by(name: 'buyer')
  UserRole.create!(user: @buyer, role: buyer_role)

  # Simulate login
  visit new_user_session_path
  fill_in 'Email', with: @buyer.email
  fill_in 'Password', with: 'password123'
  click_button 'Log in'
end

# Step: Non-moderator accesses reported listings page
When("I visit the reported listings page") do
  visit moderations_reported_listings_path
end

# Step: Verify redirection to 403 page
Then("I should be redirected to the 403 access denied page") do
  expect(page).to have_content("403 Permission Denied")
  expect(current_path).to eq(moderations_access_denied_path)
end