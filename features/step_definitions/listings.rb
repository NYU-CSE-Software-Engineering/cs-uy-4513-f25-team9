require 'capybara/cucumber'
require 'rails/test_help'

# Seller logs in
Given("I am a signed-in Seller") do
  @seller = User.create!(
    email: 'seller_test@thryft.com',
    password: 'password123',
    name: 'Test Seller'
  )

  seller_role = Role.find_by(name: 'seller')
  UserRole.create!(user: @seller, role: seller_role)

  visit new_user_session_path
  fill_in 'Email', with: @seller.email
  fill_in 'Password', with: 'password123'
  click_button 'Log in'
end

# Navigate to new listing page
Given("I am on the new listing page") do
  visit new_listing_path
end

# Fill in form fields
When("I fill in {string} with {string}") do |field, value|
  fill_in field, with: value
end

# Click button
When("I click the {string} button") do |button_text|
  click_button button_text
end

# Verify success message
Then("I should see the message {string}") do |message|
  expect(page).to have_content(message)
end

# Verify content on page
Then("I should see {string}") do |content|
  expect(page).to have_content(content)
end

# Create a listing for the seller
Given("I have a listing with name {string}") do |name|
  @listing = Listing.create!(
    name: name,
    price: 99.99,
    description: 'Test listing description',
    user_id: @seller.id,
    is_deleted: false
  )
end

# Navigate to listings page
When("I visit my listings page") do
  visit listings_path
end

# Navigate to edit page for listing
Given("I am on the edit page for that listing") do
  visit edit_listing_path(@listing)
end

# Navigate to listings page 
Given("I am on my listings page") do
  visit listings_path
end

# Click delete button for specific listing
When("I click the {string} button for {string}") do |button_text, listing_name|
  within("tr:has(td:contains('#{listing_name}'))") do
    click_button button_text
  end
end

# Verify content is not on page
Then("I should not see {string}") do |content|
  expect(page).not_to have_content(content)
end

# Verify error message
Then("I should see the error message {string}") do |error_message|
  expect(page).to have_content(error_message)
end

# Visit listing page by ID (non-existent)
When("I visit the listing page for ID {string}") do |listing_id|
  visit listing_path(listing_id)
end

# Visit edit page by ID (non-existent)
When("I visit the edit page for listing ID {string}") do |listing_id|
  visit edit_listing_path(listing_id)
end

# Submit delete request for non-existent listing
When("I submit a delete request for listing ID {string}") do |listing_id|
  page.driver.delete(listing_path(listing_id))
  visit current_path
end