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
  visit users_path
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
  visit users_path
end

Given("there is a User with name {string} and User ID {string}") do |name, user_id|
  @user = User.create!(
    id: user_id,
    name: name,
    email: "#{name.gsub(' ', '').downcase}@example.com", 
    password: 'password123'
  )
end

When("I click the {string} button for User ID {string}") do |button_text, user_id|
  # Visit or refresh the users page to ensure latest data
  visit users_path
  # Find the exact table row where the first <td> equals the user_id and click the button in that row
  xpath = "//tr[td[normalize-space(text())='#{user_id}']]"
  row = find(:xpath, xpath)
  within(row) do
    click_button button_text
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
  page.driver.submit :delete, user_path(user_id), {}
end
