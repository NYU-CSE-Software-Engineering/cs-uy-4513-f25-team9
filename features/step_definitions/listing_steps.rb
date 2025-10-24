# This step creates Listing records in the test database
# based on the table in the .feature file's Background.
Given('the following listings exist:') do |table|
  table.hashes.each do |listing_attributes|
    Listing.create!(listing_attributes)
  end
end

Given('I am on the listings page') do
  # This will fail at first because the route doesn't exist yet. That's the goal!
  visit '/listings'
end

When('I select {string} from the {string} filter') do |option, filter_label|
  select(option, from: filter_label)
end

When('I press {string}') do |button_name|
  click_button(button_name)
end

Then('I should see {string}') do |content|
  expect(page).to have_content(content)
end

Then('I should not see {string}') do |content|
  expect(page).to_not have_content(content)
end

Then('I should see the message {string}') do |message|
  expect(page).to have_content(message)
end