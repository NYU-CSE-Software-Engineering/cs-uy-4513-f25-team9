# features/step_definitions/purchase_history_steps.rb

Given('I am logged in as a buyer who has at least one completed purchase') do
  # Create a buyer and seller
  @buyer = User.create!(email: 'buyer@example.com', role: 'buyer')
  @seller = User.create!(email: 'seller@example.com', role: 'seller')
  
  # Create listings
  @older_listing = Listing.create!(
    title: 'Vintage Camera',
    price: 75.50,
    description: 'A great vintage camera',
    user: @seller
  )
  
  @newer_listing = Listing.create!(
    title: 'Modern Laptop',
    price: 899.99,
    description: 'Almost new laptop',
    user: @seller
  )
  
  # Create purchases 
  @older_purchase = Purchase.create!(
    buyer: @buyer,
    listing: @older_listing,
    price: 75.50,
    purchased_at: 3.days.ago
  )
  
  @newer_purchase = Purchase.create!(
    buyer: @buyer,
    listing: @newer_listing,
    price: 899.99,
    purchased_at: 1.day.ago
  )
  
  # Stub the current_user method (same approach as RSpec tests)
  allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@buyer)
end

Given('I am logged in as a new buyer with no purchases') do
  @buyer = User.create!(email: 'newbuyer@example.com', role: 'buyer')
  
  # Stub the current_user method
  allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@buyer)
end

When('I visit {string}') do |page_name|
  case page_name
  when 'My Purchases'
    visit '/purchases'
  else
    raise "Unknown page: #{page_name}"
  end
end

Then('I should see a view of purchased items') do
  # Verify that we got a successful response and the page contains purchase information
  expect(page.status_code).to eq(200)
  expect(page).to have_content(@newer_listing.title)
  expect(page).to have_content(@older_listing.title)
end

Then('each row shows the listing title, the final price, and the sold date') do
  # Check that newer purchase appears first
  expect(page.body.index(@newer_listing.title)).to be < page.body.index(@older_listing.title)
  
  # Verify prices are displayed
  expect(page).to have_content('899.99')
  expect(page).to have_content('75.50')
  
  # Verify dates are displayed (format: YYYY-MM-DD)
  expect(page).to have_content(@newer_purchase.purchased_at.to_date.to_s)
  expect(page).to have_content(@older_purchase.purchased_at.to_date.to_s)
end

Then('I should see {string}') do |text|
  expect(page).to have_content(text)
end