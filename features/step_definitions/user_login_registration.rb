Given('I am on the sign up page') do
  visit '/users/new'
end

When('I fill in {string} with {string}') do |field, value|
  fill_in field, with: value
end

Then('I should be redirected to the home page') do
  expect(current_path).to eq('/')
end

Then('I should remain on the sign up page') do
  expect(['/users/new', '/users']).to include(current_path)
end

Given('I have an account with email {string} and password {string}') do |email, password|
  User.where(email: email).destroy_all
  @user = User.create!(email: email, password: password)
end

Given('I am on the sign in page') do
  visit '/login'
end

Then('I should see a {string} link') do |link_text|
  expect(page).to have_link(link_text)
end

Then('I should remain on the sign in page') do
  expect(current_path).to eq('/login')
end

Given('I am logged in as a user with email {string}') do |email|
  User.where(email: email).destroy_all
  @user = User.create!(email: email, password: 'password123')
  allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
end