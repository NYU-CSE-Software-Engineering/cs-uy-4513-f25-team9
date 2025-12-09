Given("I am viewing a product listing from another user") do
  @seller = User.create!(email: "seller@example.com", password: "password123")
  @listing = Listing.create!(title: "Test Camera", description: "Great condition", price: 100, user: @seller)
  visit listing_path(@listing)
end

Given("I am on the message composition page for a product") do
  @seller = User.create!(email: "seller@example.com", password: "password123")
  @listing = Listing.create!(title: "Test Item", description: "Test description", price: 50, user: @seller)
  visit new_listing_conversation_path(listing_id: @listing.id)
end

When("I click {string}") do |button_text|
  if button_text == "Report listing"
    click_link button_text
  elsif button_text == "Message Seller"
    click_link button_text
  else
    # Try link first, then button
    if page.has_link?(button_text)
      click_link button_text
    else
      click_button button_text
    end
  end
end

When("I fill in the message with {string}") do |message_content|
  fill_in "Your message:", with: message_content
end

When("I click {string} without entering any text") do |button_text|
  click_button button_text
end

Then("I should see an error message {string}") do |error_message|
  expect(page).to have_content(error_message)
end

Then("the message should be saved in the conversation") do
  expect(Message.last.content).to eq("Is this item still available?")
  expect(Message.last.conversation).to eq(Conversation.last)
end