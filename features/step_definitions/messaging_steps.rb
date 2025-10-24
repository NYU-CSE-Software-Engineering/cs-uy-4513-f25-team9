Given("I am logged in as a buyer") do
  @buyer = User.create!(email: "buyer@example.com", password: "password123", name: "Test Buyer")
  # Assign buyer role - adjust based on your role system
  visit new_user_session_path
  fill_in "Email", with: @buyer.email
  fill_in "Password", with: @buyer.password
  click_button "Log in"
end

Given("I am viewing a product listing from another user") do
  @seller = User.create!(email: "seller@example.com", password: "password123", name: "Test Seller")
  @listing = Listing.create!(title: "Vintage Camera", description: "Great condition", price: 100, user: @seller)
  visit listing_path(@listing)
end

Given("I am logged in as a user with existing conversations") do
  @user = User.create!(email: "user@example.com", password: "password123", name: "Test User")
  @other_user = User.create!(email: "other@example.com", password: "password123", name: "Other User")
  @listing = Listing.create!(title: "Test Item", user: @other_user)
  @conversation = Conversation.create!(buyer: @user, seller: @other_user, listing: @listing)
  @message = Message.create!(content: "Hello, is this available?", user: @user, conversation: @conversation)
  
  visit new_user_session_path
  fill_in "Email", with: @user.email
  fill_in "Password", with: @user.password
  click_button "Log in"
end

Given("I have unread messages in my conversation") do
  @user = User.create!(email: "user@example.com", password: "password123", name: "Test User")
  @other_user = User.create!(email: "other@example.com", password: "password123", name: "Other User")
  @listing = Listing.create!(title: "Test Item", user: @other_user)
  @conversation = Conversation.create!(buyer: @user, seller: @other_user, listing: @listing)
  @message = Message.create!(content: "New message for you!", user: @other_user, conversation: @conversation, read: false)
  
  visit new_user_session_path
  fill_in "Email", with: @user.email
  fill_in "Password", with: @user.password
  click_button "Log in"
end

Given("I am on the message composition page for a product") do
  visit new_conversation_path(listing_id: @listing.id)
end

When("I click {string}") do |button_text|
  click_button button_text
end

When("I fill in the message with {string}") do |message_content|
  fill_in "message_content", with: message_content
end

When("I visit my messages page") do
  visit conversations_path
end

When("I visit the dashboard") do
  visit root_path  # or whatever your dashboard path is
end

When("I view the conversation") do
  visit conversation_path(@conversation)
end

Then("I should see {string}") do |expected_text|
  expect(page).to have_content(expected_text)
end

Then("the message should be saved in the conversation") do
  expect(Message.last.content).to eq("Is this item still available?")
  expect(Message.last.conversation).to eq(Conversation.last)
end

Then("I should see a list of my conversations") do
  expect(page).to have_css('.conversations-list')
end

Then("I should see the last message preview and timestamp for each conversation") do
  expect(page).to have_content(@message.content)
  # Assuming you display timestamps
  expect(page).to have_css('.message-timestamp')
end

Then("I should see a notification indicator for unread messages") do
  expect(page.has_css?('.unread-indicator') || page.has_content?('New messages')).to be true
end

Then("the unread messages should be marked as read") do
  @message.reload
  expect(@message.read).to be true
end

When("I click {string} without entering any text") do |button_text|
  click_button button_text
end

Then("I should see an error message {string}") do |error_message|
  expect(page).to have_content(error_message)
end

When("when I view the conversation") do
  visit conversation_path(@conversation)
end