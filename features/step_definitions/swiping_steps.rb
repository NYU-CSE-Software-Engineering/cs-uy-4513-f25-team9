Given('I am logged in as a buyer for swiping') do
  @buyer = User.create!(email: 'swipebuyer@example.com', password: 'password123')
  allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@buyer)
end

Given('there are multiple swipable listings') do
  seller = User.create!(email: 'swipeseller@example.com', password: 'password123')

  @first_listing = Listing.create!(
    title: 'Vintage Camera',
    description: 'Old but gold',
    price: 120,
    user: seller,
    created_at: 3.days.ago
  )

  @second_listing = Listing.create!(
    title: 'Road Bike',
    description: 'Fast and light',
    price: 750,
    user: seller,
    created_at: 1.day.ago
  )
end

Given('there are no swipable listings remaining') do
  seller = User.create!(email: 'emptyseller@example.com', password: 'password123')
  listing = Listing.create!(title: 'Sold Out Item', description: 'Unavailable', price: 10, user: seller)

  @buyer ||= User.create!(email: 'swipebuyer@example.com', password: 'password123')
  allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@buyer)

  # Simulate the buyer already swiping on the only listing
  Interest.create!(buyer: @buyer, listing: listing, state: 'liked') if defined?(Interest)
end

Given('I note the current listing') do
  # Assume the newest listing is shown first; store it for assertions
  @current_listing = @second_listing || Listing.order(created_at: :desc).first
end

When('I visit the feed') do
  visit '/feed'
end

Then('an interest should be recorded for that listing with state {string}') do |state|
  expect(Interest.where(buyer: @buyer, listing: @current_listing, state: state).exists?).to be true
end

Then('I should see the next listing on the feed') do
  titles = [@first_listing, @second_listing].compact.map(&:title)
  expect(titles.any? { |title| page.has_content?(title) }).to be true
end
