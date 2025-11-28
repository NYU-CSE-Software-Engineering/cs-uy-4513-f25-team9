# features/step_definitions/listings_steps.rb

Given('I am logged in as a seller') do
  @seller = User.create!(email: 'seller@example.com', password: 'password123')
  allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@seller)
end

Given('I have a listing titled {string}') do |title|
  @listing = Listing.create!(
    title: title,
    price: 100.00,
    description: 'Test description',
    user: @seller
  )
end

When('I create a listing titled {string} with price {string}') do |title, price|
  visit new_listing_path
  fill_in 'Title', with: title
  fill_in 'Price', with: price
  fill_in 'Description', with: 'Test description'
  click_button 'Submit'
end

When('I visit the listings page') do
  visit listings_path
end

When('I update that listing to {string}') do |new_title|
  visit edit_listing_path(@listing)
  fill_in 'Title', with: new_title
  click_button 'Submit'
end

When('I delete that listing') do
  visit listings_path
  within("#listing_#{@listing.id}") do
    click_link 'Delete'
  end
end

Then('I should see {string}') do |text|
  expect(page).to have_content(text)
end
