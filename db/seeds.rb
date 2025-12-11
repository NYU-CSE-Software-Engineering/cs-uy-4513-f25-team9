# Clear existing data
puts "Clearing existing data..."
Message.destroy_all
Conversation.destroy_all
Report.destroy_all
Listing.destroy_all
User.destroy_all

require 'open-uri'

# Create users
puts "Creating users..."
user1 = User.create!(
  email: "seller@example.com",
  name: "Sarah Johnson",
  password: "password123",
  password_confirmation: "password123"
)

user2 = User.create!(
  email: "john@example.com",
  name: "John Smith",
  password: "password123",
  password_confirmation: "password123"
)

user3 = User.create!(
  email: "test@example.com",
  name: "Test User",
  password: "password123",
  password_confirmation: "password123"
)

# Create admin user
user4 = User.create!(
  email: "admin@example.com",
  name: "Admin User",
  password: "adminpassword",
  password_confirmation: "adminpassword",
  is_admin: true,
  is_moderator: true
)

# Create moderator user
moderator = User.create!(
  email: "moderator@example.com",
  name: "Moderator User",
  password: "password123",
  password_confirmation: "password123",
  is_moderator: true
)

puts "Created #{User.count} users"

# Categories
categories = ["Electronics", "Clothing", "Books", "Furniture", "Sports", "Home & Garden"]

# Create listings for user1
puts "Creating listings..."

listings_data = [
  {
    title: "MacBook Pro 2021 - 16 inch",
    description: "Gently used MacBook Pro with M1 Pro chip, 16GB RAM, 512GB SSD. Includes original charger and box. Perfect condition, no scratches.",
    price: 1899.99,
    category: "Electronics",
    image_url: "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400"
  },
  {
    title: "Vintage Leather Jacket",
    description: "Classic brown leather jacket from the 80s. Size Medium. Genuine leather, well-maintained. Perfect for anyone looking for that retro style.",
    price: 120.00,
    category: "Clothing",
    image_url: "https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400"
  },
  {
    title: "The Great Gatsby - First Edition",
    description: "Rare first edition of The Great Gatsby by F. Scott Fitzgerald. Great condition for its age. A must-have for collectors.",
    price: 450.00,
    category: "Books",
    image_url: "https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400"
  },
  {
    title: "Modern Coffee Table",
    description: "Beautiful minimalist coffee table made of oak wood. Dimensions: 48x24x18 inches. Barely used, like new condition.",
    price: 200.00,
    category: "Furniture",
    image_url: "https://images.unsplash.com/photo-1518455027359-f3f8164ba6bd?w=400"
  },
  {
    title: "Mountain Bike - Trek X-Caliber",
    description: "Trek X-Caliber mountain bike with 29-inch wheels. Recently serviced, new tires. Perfect for trails and off-road adventures.",
    price: 650.00,
    category: "Sports",
    image_url: "https://images.unsplash.com/photo-1576435728678-68d0fbf94e91?w=400"
  },
  {
    title: "Electric Lawn Mower",
    description: "Eco-friendly electric lawn mower with a 14-inch cutting width. Lightweight and easy to use. Great for small to medium yards.",
    price: 180.00,
    category: "Home & Garden",
    image_url: "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400"
  },
  {
    title: "iPhone 13 Pro - 256GB",
    description: "iPhone 13 Pro in Sierra Blue. 256GB storage, unlocked for all carriers. Includes original box and accessories. Screen protector applied since day one.",
    price: 799.99,
    category: "Electronics",
    image_url: "https://images.unsplash.com/photo-1591337676887-a217a6970a8a?w=400"
  },
  {
    title: "Designer Winter Coat",
    description: "Women's winter coat from a luxury brand. Size Small. Navy blue, down-filled, extremely warm. Only worn a few times.",
    price: 300.00,
    category: "Clothing",
    image_url: "https://images.unsplash.com/photo-1539533018447-63fcce2678e3?w=400"
  }
]

listings_data.each do |listing_data|
  listing = user1.listings.create!(
    title: listing_data[:title],
    description: listing_data[:description],
    price: listing_data[:price],
    category: listing_data[:category]
  )
  
  if listing_data[:image_url]
    begin
      file = URI.open(listing_data[:image_url])
      listing.image.attach(io: file, filename: "#{listing_data[:title].parameterize}.jpg")
      puts "✓ Created #{listing.title} with image"
    rescue => e
      puts "✗ Created #{listing.title} but failed to attach image: #{e.message}"
    end
  end
end

# Create some listings for user2
user2_listings = [
  {
    title: "Sony WH-1000XM4 Headphones",
    description: "Premium noise-cancelling wireless headphones. Excellent sound quality, comfortable for long use. Includes carrying case.",
    price: 280.00,
    category: "Electronics",
    image_url: "https://images.unsplash.com/photo-1545127398-14699f92334b?w=400"
  },
  {
    title: "Yoga Mat & Block Set",
    description: "High-quality yoga mat with alignment lines, includes two foam blocks. Perfect for home workouts or studio practice.",
    price: 45.00,
    category: "Sports",
    image_url: "https://images.unsplash.com/photo-1601925260368-ae2f83cf8b7f?w=400"
  },
  {
    title: "Vintage Record Player",
    description: "Fully functional vintage record player from the 1970s. Great sound quality, comes with a collection of 20 vinyl records.",
    price: 350.00,
    category: "Electronics",
    image_url: "https://images.unsplash.com/photo-1603048588665-791ca8ffe39a?w=400"
  }
]

user2_listings.each do |listing_data|
  listing = user2.listings.create!(
    title: listing_data[:title],
    description: listing_data[:description],
    price: listing_data[:price],
    category: listing_data[:category]
  )
  
  if listing_data[:image_url]
    begin
      file = URI.open(listing_data[:image_url])
      listing.image.attach(io: file, filename: "#{listing_data[:title].parameterize}.jpg")
      puts "✓ Created #{listing.title} with image"
    rescue => e
      puts "✗ Created #{listing.title} but failed to attach image: #{e.message}"
    end
  end
end

# Create one listing for user3
listing = user3.listings.create!(
  title: "Gaming Chair - Racing Style",
  description: "Ergonomic gaming chair with lumbar support and adjustable armrests. Red and black design. Very comfortable for long gaming sessions.",
  price: 220.00,
  category: "Furniture"
)

begin
  file = URI.open("https://images.unsplash.com/photo-1598550476439-6847785fcea6?w=400")
  listing.image.attach(io: file, filename: "gaming-chair-racing-style.jpg")
  puts "✓ Created #{listing.title} with image"
rescue => e
  puts "✗ Created #{listing.title} but failed to attach image: #{e.message}"
end

puts "Created #{Listing.count} listings"

# Create some reports for testing moderation
puts "Creating test reports..."
# Report some listings as fraudulent for testing
fraudulent_listing1 = user1.listings.first
fraudulent_listing2 = user2.listings.first

if fraudulent_listing1 && fraudulent_listing2
  Report.create!(
    user: user2,
    listing: fraudulent_listing1,
    reason: "Suspicious pricing - too good to be true"
  )
  
  Report.create!(
    user: user3,
    listing: fraudulent_listing1,
    reason: "Product description seems fake"
  )
  
  Report.create!(
    user: user1,
    listing: fraudulent_listing2,
    reason: "Fraudulent listing - seller not responding"
  )
  
  # Add more reported listings
  Report.create!(
    user: user3,
    listing: user2.listings.last,
    reason: "Item is damaged but seller claims it's in perfect condition"
  )
  
  Report.create!(
    user: user1,
    listing: user3.listings.first,
    reason: "Overpriced compared to market value"
  )
  
  puts "Created #{Report.count} reports"
end

# Create conversations and messages
puts "Creating conversations and messages..."

# Conversation 1: user2 interested in user1's MacBook
listing1 = user1.listings.find_by(title: "MacBook Pro 2021 - 16 inch")
if listing1
  conv1 = Conversation.create!(
    buyer_id: user2.id,
    seller_id: user1.id,
    listing_id: listing1.id
  )
  
  Message.create!([
    {
      conversation: conv1,
      user: user2,
      content: "Hi! Is the MacBook still available? I'm very interested!",
      read: true,
      created_at: 3.days.ago
    },
    {
      conversation: conv1,
      user: user1,
      content: "Yes, it's still available! It's in excellent condition, barely used.",
      read: true,
      created_at: 3.days.ago + 30.minutes
    },
    {
      conversation: conv1,
      user: user2,
      content: "Great! Does it come with the original box and accessories?",
      read: true,
      created_at: 3.days.ago + 1.hour
    },
    {
      conversation: conv1,
      user: user1,
      content: "Yes! It includes the original box, charger, and USB-C cable. I also kept the Apple stickers if you want them 😊",
      read: true,
      created_at: 3.days.ago + 2.hours
    },
    {
      conversation: conv1,
      user: user2,
      content: "Perfect! Would you be willing to meet at the campus coffee shop tomorrow around 2pm?",
      read: false,
      created_at: 2.days.ago
    }
  ])
  puts "✓ Created conversation about MacBook with #{conv1.messages.count} messages"
end

# Conversation 2: user3 interested in user2's headphones
listing2 = user2.listings.find_by(title: "Sony WH-1000XM4 Headphones")
if listing2
  conv2 = Conversation.create!(
    buyer_id: user3.id,
    seller_id: user2.id,
    listing_id: listing2.id
  )
  
  Message.create!([
    {
      conversation: conv2,
      user: user3,
      content: "Hey! How long have you had these headphones?",
      read: true,
      created_at: 5.days.ago
    },
    {
      conversation: conv2,
      user: user2,
      content: "I've had them for about 6 months. They work perfectly, I'm just upgrading to a newer model.",
      read: true,
      created_at: 5.days.ago + 1.hour
    },
    {
      conversation: conv2,
      user: user3,
      content: "Do they have any scratches or wear marks?",
      read: true,
      created_at: 5.days.ago + 3.hours
    },
    {
      conversation: conv2,
      user: user2,
      content: "Minor wear on the headband padding, but nothing significant. The ear cups are in great shape. I can send you more photos if you'd like!",
      read: true,
      created_at: 4.days.ago
    },
    {
      conversation: conv2,
      user: user3,
      content: "That would be great, thanks! Also, is the noise cancellation still working well?",
      read: true,
      created_at: 4.days.ago + 30.minutes
    },
    {
      conversation: conv2,
      user: user2,
      content: "Absolutely! The noise cancellation is one of the best features. Works like new.",
      read: false,
      created_at: 4.days.ago + 2.hours
    }
  ])
  puts "✓ Created conversation about headphones with #{conv2.messages.count} messages"
end

# Conversation 3: user1 interested in user3's gaming chair
listing3 = user3.listings.find_by(title: "Gaming Chair - Racing Style")
if listing3
  conv3 = Conversation.create!(
    buyer_id: user1.id,
    seller_id: user3.id,
    listing_id: listing3.id
  )
  
  Message.create!([
    {
      conversation: conv3,
      user: user1,
      content: "Hi! Does this chair support tall people? I'm 6'2\"",
      read: true,
      created_at: 1.day.ago
    },
    {
      conversation: conv3,
      user: user3,
      content: "Yes definitely! I'm 6'1\" and it's been very comfortable for me. The backrest is adjustable too.",
      read: true,
      created_at: 1.day.ago + 45.minutes
    },
    {
      conversation: conv3,
      user: user1,
      content: "Awesome! Can I come check it out this weekend?",
      read: false,
      created_at: 1.day.ago + 2.hours
    }
  ])
  puts "✓ Created conversation about gaming chair with #{conv3.messages.count} messages"
end

# Conversation 4: user2 interested in user1's coffee table
listing4 = user1.listings.find_by(title: "Modern Coffee Table")
if listing4
  conv4 = Conversation.create!(
    buyer_id: user2.id,
    seller_id: user1.id,
    listing_id: listing4.id
  )
  
  Message.create!([
    {
      conversation: conv4,
      user: user2,
      content: "Beautiful table! Is it solid oak or veneer?",
      read: true,
      created_at: 6.days.ago
    },
    {
      conversation: conv4,
      user: user1,
      content: "Thanks! It's solid oak, very sturdy and heavy.",
      read: true,
      created_at: 6.days.ago + 20.minutes
    },
    {
      conversation: conv4,
      user: user2,
      content: "Would you be able to help deliver it? I don't have a truck.",
      read: true,
      created_at: 6.days.ago + 1.hour
    },
    {
      conversation: conv4,
      user: user1,
      content: "If you're on campus or nearby, I can probably help. Where are you located?",
      read: true,
      created_at: 5.days.ago
    },
    {
      conversation: conv4,
      user: user2,
      content: "I'm in the dorms on campus. That would be amazing if you could help!",
      read: false,
      created_at: 5.days.ago + 30.minutes
    }
  ])
  puts "✓ Created conversation about coffee table with #{conv4.messages.count} messages"
end

# Conversation 5: user3 interested in user2's vinyl record player
listing5 = user2.listings.find_by(title: "Vintage Record Player")
if listing5
  conv5 = Conversation.create!(
    buyer_id: user3.id,
    seller_id: user2.id,
    listing_id: listing5.id
  )
  
  Message.create!([
    {
      conversation: conv5,
      user: user3,
      content: "Wow, this is exactly what I've been looking for! What records are included?",
      read: true,
      created_at: 8.hours.ago
    },
    {
      conversation: conv5,
      user: user2,
      content: "Mix of classic rock and jazz - Pink Floyd, Led Zeppelin, Miles Davis, Coltrane, and more!",
      read: false,
      created_at: 6.hours.ago
    }
  ])
  puts "✓ Created conversation about record player with #{conv5.messages.count} messages"
end

puts "Created #{Conversation.count} conversations"
puts "Created #{Message.count} messages"

puts "\n=== Seed Data Summary ==="
puts "Users created: #{User.count}"
puts "Listings created: #{Listing.count}"
puts "Reports created: #{Report.count}"
puts "Conversations created: #{Conversation.count}"
puts "Messages created: #{Message.count}"
puts "\nTest accounts:"
puts "Email: seller@example.com | Password: password123 (#{user1.listings.count} listings)"
puts "Email: john@example.com | Password: password123 (#{user2.listings.count} listings)"
puts "Email: test@example.com | Password: password123 (#{user3.listings.count} listing)"
puts "Email: admin@example.com | Password: adminpassword (Admin User)"
puts "Email: moderator@example.com | Password: password123 (Moderator - can access moderation pages)"
puts "\nRun: rails db:seed"
