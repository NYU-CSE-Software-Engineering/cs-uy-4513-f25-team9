# features/step_definitions/purchase_history_steps.rb

Given('I am logged in as a buyer who has at least one completed purchase') do
  # Create a buyer and seller
  @buyer = User.create!(email: 'buyer@example.com', password: 'password123')
  @seller = User.create!(email: 'seller@example.com', password: 'password123')
  
  # Create listings
  @older_listing = Listing.create!(
    title: 'Vintage Camera',
    price: 75.50,
    user: @seller
  )
  
  @newer_listing = Listing.create!(
    title: 'Modern Laptop',
    price: 899.99,
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
  @buyer = User.create!(email: 'newbuyer@example.com', password: 'password123')
  
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

# Note: "I am not logged in" and "I should be redirected to the login page" 
# are defined in report_steps.rb to avoid ambiguity
# These steps are removed from here to prevent duplicate step definitions

Given('I am logged in as a buyer with a purchase of a deleted listing') do
  @buyer = User.create!(email: 'buyer@example.com', password: 'password123')
  @seller = User.create!(email: 'seller@example.com', password: 'password123')
  
  @listing = Listing.create!(
    title: 'Deleted Item',
    price: 50.00,
    user: @seller
  )
  
  @purchase = Purchase.create!(
    buyer: @buyer,
    listing: @listing,
    price: 50.00,
    purchased_at: 1.day.ago
  )
  
  # Simulate deleted listing by setting listing_id to nil
  # This simulates what happens when listing is deleted with on_delete: :nullify
  # In real scenario, the migration would handle this automatically
  @purchase.update_column(:listing_id, nil)
  
  allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@buyer)
end

Then('I should see the purchase in my history') do
  expect(page.status_code).to eq(200)
  expect(page).to have_content('50.00')
end

Then('I should see {string} for that purchase') do |text|
  expect(page).to have_content(text)
end

Given('I am logged in as a buyer with multiple purchases on the same day') do
  @buyer = User.create!(email: 'buyer@example.com', password: 'password123')
  @seller = User.create!(email: 'seller@example.com', password: 'password123')
  
  same_day = 2.days.ago.beginning_of_day
  
  @first_purchase = Purchase.create!(
    buyer: @buyer,
    listing: Listing.create!(title: 'First Item', price: 10.00, user: @seller),
    price: 10.00,
    purchased_at: same_day + 2.hours
  )
  
  @second_purchase = Purchase.create!(
    buyer: @buyer,
    listing: Listing.create!(title: 'Second Item', price: 20.00, user: @seller),
    price: 20.00,
    purchased_at: same_day + 4.hours
  )
  
  @third_purchase = Purchase.create!(
    buyer: @buyer,
    listing: Listing.create!(title: 'Third Item', price: 30.00, user: @seller),
    price: 30.00,
    purchased_at: same_day + 6.hours
  )
  
  allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@buyer)
end

Then('I should see all purchases from that day') do
  expect(page).to have_content('First Item')
  expect(page).to have_content('Second Item')
  expect(page).to have_content('Third Item')
end

Then('they should be ordered by creation time') do
  body = page.body
  # Third should appear first (most recent), then second, then first
  expect(body.index('Third Item')).to be < body.index('Second Item')
  expect(body.index('Second Item')).to be < body.index('First Item')
end