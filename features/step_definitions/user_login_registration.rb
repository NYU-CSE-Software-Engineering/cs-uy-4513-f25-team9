Given('I am on the sign up page') do
  visit '/users/new'
end

When('I fill in "Email" with {string}') do |value|
  fill_in 'Email', with: value
end

When('I fill in "Password" with {string}') do |value|
  fill_in 'Password', with: value
end

When('I fill in "Password confirmation" with {string}') do |value|
  fill_in 'Password confirmation', with: value
end

When('I click the auth button {string}') do |text|
  if page.has_button?(text)
    click_button text
  elsif page.has_link?(text)
    click_link text
  else
    raise "No button or link found for '#{text}'"
  end
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

Given('I am logged in as a user with email {string} and password {string}') do |email, password|
  User.where(email: email).destroy_all
  User.create!(email: email, password: password)

  visit '/login'
  fill_in 'Email', with: email
  fill_in 'Password', with: password
  click_button 'Log in'

  puts "DEBUG CURRENT PATH = #{current_path}"   # <--- ADD THIS
  puts page.body      
end
