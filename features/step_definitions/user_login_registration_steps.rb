# features/step_definitions/auth_steps.rb
require 'capybara/cucumber'
require 'rails/test_help'

# Sign up steps
Given('I am on the Sign Up page') do
  # Navigates to the Devise registration page
  visit new_user_registration_path rescue visit '/users/sign_up'
end

When('I fill in {string} with {string}') do |field, value|
  fill_in field, with: value
end

When('I press the {string} button') do |button|
  click_button button
end

Then('I should be redirected to the Home page') do
  expect(page).to have_current_path(root_path, ignore_query: true)
end

Then('I should see the {string} link') do |link_text|
  expect(page).to have_link(link_text)
end

Then('I should remain on the Sign Up page') do
  expect(page).to have_current_path(new_user_registration_path, ignore_query: true)
  expect(page).to have_content('Sign up')
end

# Creating user for testing
Given('a User exists with email {string} and password {string}') do |email, password|
  User.create!(email: email, password: password, password_confirmation: password)
end

# Sign in steps
Given('I am on the Sign In page') do
  visit new_user_session_path rescue visit '/users/sign_in'
end

Then('I should remain on the Sign In page') do
  # Confirms the user stayed on the login page after invalid credentials
  expect(page).to have_current_path(new_user_session_path, ignore_query: true)
  expect(page).to have_content('Log in')
end

Given('I am signed in as {string} with password {string}') do |email, password|
  # Signs in an existing user (creates one if it doesn’t exist)
  user = User.find_or_create_by!(email: email) do |u|
    u.password = password
    u.password_confirmation = password
  end

  visit new_user_session_path
  fill_in 'Email', with: user.email
  fill_in 'Password', with: password
  click_button 'Log in'
end

When('I click the {string} link') do |link_text|
  click_link link_text
end
