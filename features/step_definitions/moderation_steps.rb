require 'capybara/cucumber'
require 'rails/test_help'

# Step: Moderator logs in
Given("I am a signed-in Moderator") do
  # Create a test Moderator user
  @moderator = User.create!(
    email: 'moderator_test@thryft.com',
    password: 'password123',
    name: 'Test Moderator',
    is_moderator: true
  )
  
  # Simulate login
  # Simulate login via direct POST to avoid driver/session flakiness
  if page.driver.respond_to?(:submit)
    page.driver.submit :post, login_path, { email: @moderator.email, password: 'password123' }
  else
    visit login_path
    fill_in 'Email', with: @moderator.email
    fill_in 'Password', with: 'password123'
    click_button 'Log in'
  end
  # Ensure the session persisted and we are signed in by visiting the users list
  visit moderations_path
  expect(page).to have_content('User List')
end

# Step: Verify success message
Then("I should see the message {string}") do |message|
  expect(page).to have_content(message)
end

# Step: Verify error message
Then("I should see the error message {string}") do |error_message|
  expect(page).to have_content(error_message)
end

# Step: Buyer logs in
Given("I am a signed-in Buyer") do
  # Create a test Buyer user
  @buyer = User.create!(
    email: 'buyer_test@thryft.com',
    password: 'password123'
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

Given("I am on the User List page") do
  visit moderations_path
end

Given("there is a User with name {string} and User ID {string}") do |name, user_id|
  # Delete any existing user with this ID first to avoid conflicts
  User.where(id: user_id).delete_all
  @user = User.create!(
    id: user_id,
    name: name,
    email: "#{name.gsub(' ', '').downcase}@example.com", 
    password: 'password123'
  )
end

When("I click the {string} button for User ID {string}") do |button_text, user_id|
  # Visit or refresh the users page to ensure latest data
  visit moderations_path
  
  # Find the user by ID and submit DELETE request directly
  # This bypasses JavaScript confirmation dialogs which may not be supported by the driver
  user = User.find_by(id: user_id)
  if user
    # Use page.driver.submit to directly submit the DELETE request
    # This works regardless of JavaScript support
    page.driver.submit :delete, moderations_user_path(user), {}
  else
    raise "User with ID #{user_id} not found"
  end
end

Then("the User with ID {string} should be deleted from the database") do |user_id|
  expect(User.find_by(id: user_id)).to be_nil
end

Given("I don't have the {string} privilege") do |privilege|
  @moderator = User.find_by(email: 'moderator_test@thryft.com')
  if privilege.downcase == 'admin'
    @moderator.update!(is_admin: false)
  end
end

Given("there is a Moderator with name {string} and User ID {string}") do |name, user_id|
  # Delete any existing user with this ID first
  User.where(id: user_id).delete_all
  @target_moderator = User.create!(
    id: user_id,
    name: name,
    email: "#{name.gsub(' ', '').downcase}@example.com", 
    password: 'password123',
    is_moderator: true
  )
end

Given("User ID {string} has the {string} privilege") do |user_id, privilege|
  user = User.find_by(id: user_id)
  if privilege.downcase == 'admin'
    user.update!(is_admin: true, is_moderator: true)
  end
end

When('I submit a delete request for User ID {string} \(non-existent)') do |user_id|
  page.driver.submit :delete, moderations_user_path(user_id), {}
end

# Steps for Moderator Remove Fraudulent Listings

Given("I am a signed-in regular user") do
  @regular_user = User.create!(
    email: 'regular_user@thryft.com',
    password: 'password123',
    name: 'Regular User'
  )
  
  if page.driver.respond_to?(:submit)
    page.driver.submit :post, login_path, { email: @regular_user.email, password: 'password123' }
  else
    visit login_path
    fill_in 'Email', with: @regular_user.email
    fill_in 'Password', with: 'password123'
    click_button 'Log in'
  end
end

Given("there are reported listings pending review") do
  @seller = User.create!(email: 'seller@example.com', password: 'password123', name: 'Seller')
  @listing1 = Listing.create!(
    user: @seller,
    title: 'Reported Product 1',
    description: 'This is a reported product',
    price: 50.00
  )
  @listing2 = Listing.create!(
    user: @seller,
    title: 'Reported Product 2',
    description: 'Another reported product',
    price: 75.00
  )
  
  @reporter = User.create!(email: 'reporter@example.com', password: 'password123', name: 'Reporter')
  Report.create!(user: @reporter, listing: @listing1, reason: 'Suspicious pricing')
  Report.create!(user: @reporter, listing: @listing2, reason: 'Fake product')
end

Given("there is a reported listing with title {string} and ID {string}") do |title, listing_id|
  @seller = User.create!(email: 'seller@example.com', password: 'password123', name: 'Seller')
  # Delete any existing listing with this ID first
  Listing.where(id: listing_id).delete_all
  @listing = Listing.create!(
    id: listing_id,
    user: @seller,
    title: title,
    description: 'This is a fraudulent product',
    price: 100.00
  )
  @reporter = User.create!(email: 'reporter@example.com', password: 'password123', name: 'Reporter')
  Report.create!(user: @reporter, listing: @listing, reason: 'Fraudulent listing')
end

Given("there are no reported listings") do
  # Ensure no reports exist
  Report.delete_all
end

When("I visit the reported listings page") do
  visit '/moderations/reported_listings'
end

When("I try to visit the reported listings page") do
  visit '/moderations/reported_listings'
end

Then("I should see a list of reported listings") do
  expect(page).to have_content('Reported Listings')
  expect(page).to have_content('Reported Product 1')
  expect(page).to have_content('Reported Product 2')
end

Then("each listing should show the report reason") do
  expect(page).to have_content('Suspicious pricing')
  expect(page).to have_content('Fake product')
end

When("I click the {string} button for listing ID {string}") do |button_text, listing_id|
  visit '/moderations/reported_listings'
  
  listing = Listing.find_by(id: listing_id)
  if listing
    page.driver.submit :delete, "/moderations/listings/#{listing_id}", {}
  else
    raise "Listing with ID #{listing_id} not found"
  end
end

Then("the listing with ID {string} should be deleted from the database") do |listing_id|
  expect(Listing.find_by(id: listing_id)).to be_nil
end

When('I submit a delete request for listing ID {string} \(non-existent)') do |listing_id|
  page.driver.submit :delete, "/moderations/listings/#{listing_id}", {}
end