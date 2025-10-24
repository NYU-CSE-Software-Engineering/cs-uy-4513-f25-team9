# frozen_string_literal: true

Given("I am a signed-in buyer") do
    @buyer = User.create!(email: "buyer_#{SecureRandom.hex(4)}@ex.com",
                          password: "secret123", role: "buyer")
    visit new_user_session_path
    fill_in "Email", with: @buyer.email
    fill_in "Password", with: "secret123"
    click_button "Log in"
  end
  
  Given("the following swipeable listings exist:") do |table|
    table.hashes.each do |row|
      seller = User.create!(email: "seller_#{SecureRandom.hex(4)}@ex.com",
                            password: "secret123", role: "seller")
      Listing.create!(
        seller_id: seller.id,
        title: row["title"],
        category: row["category"],
        price_cents: row["price_cents"],
        status: row["status"]
      )
    end
  end
  
  Given("I have not swiped any listings") do
    Interest.where(buyer_id: @buyer&.id).delete_all
  end
  
  When("I visit the feed") do
    visit feed_path
  end
  
  Given("I am on the feed") do
    visit feed_path
    @last_seen_title = page.first(".listing-title, h1, h2")&.text
  end
  
  Then("I should see {string}") do |text|
    expect(page).to have_content(text)
    @last_seen_title = text
  end
  
  When("I press {string}") do |label|
    click_button label
  end
  
  Then("my like for {string} is saved") do |title|
    listing = Listing.find_by!(title: title)
    expect(Interest.exists?(buyer_id: @buyer.id, listing_id: listing.id, state: "liked")).to be(true)
  end
  
  Then("my pass for the current listing is saved") do
    listing = Listing.find_by!(title: @last_seen_title)
    expect(Interest.exists?(buyer_id: @buyer.id, listing_id: listing.id, state: "passed")).to be(true)
  end
  
  Then("I should see the next listing card") do
    expect(page).not_to have_content(@last_seen_title) if @last_seen_title
  end
  
  Given("I have already liked {string}") do |title|
    listing = Listing.find_by!(title: title)
    Interest.find_or_create_by!(buyer_id: @buyer.id, listing_id: listing.id) { |i| i.state = "liked" }
  end
  
  When("I try to like {string} again from any page") do |title|
    listing = Listing.find_by!(title: title)
    page.driver.submit :post, swipes_path, { listing_id: listing.id, direction: "right" }
  end
  
  Then("it should not create a duplicate interest") do
    counts = Interest.group(:buyer_id, :listing_id).count.values
    expect(counts).to all(eq(1))
  end
  
  Given("I set the category filter to {string}") do |category|
    @filter_category = category
  end
  
  Then("I should not see {string}") do |text|
    expect(page).not_to have_content(text)
  end
  
  Given("there are no active, unswiped listings for my filters") do
    Listing.where(status: "active").find_each do |lst|
      Interest.find_or_create_by!(buyer_id: @buyer.id, listing_id: lst.id) { |i| i.state = "passed" }
    end
  end
  
  Then("I should see a link to {string}") do |link_text|
    expect(page).to have_link(link_text)
  end
  
  Given("I am signed out") do
    Capybara.reset_sessions!
  end
  
  Then("I should be redirected to the login page") do
    expect(page).to have_current_path(new_user_session_path, ignore_query: true).or have_content("Log in")
  end
  