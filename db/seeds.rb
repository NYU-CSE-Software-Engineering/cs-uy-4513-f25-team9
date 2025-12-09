# Clear existing data
puts "Clearing existing data..."
Listing.destroy_all
User.destroy_all

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
    category: "Electronics"
  },
  {
    title: "Vintage Leather Jacket",
    description: "Classic brown leather jacket from the 80s. Size Medium. Genuine leather, well-maintained. Perfect for anyone looking for that retro style.",
    price: 120.00,
    category: "Clothing"
  },
  {
    title: "The Great Gatsby - First Edition",
    description: "Rare first edition of The Great Gatsby by F. Scott Fitzgerald. Great condition for its age. A must-have for collectors.",
    price: 450.00,
    category: "Books"
  },
  {
    title: "Modern Coffee Table",
    description: "Beautiful minimalist coffee table made of oak wood. Dimensions: 48x24x18 inches. Barely used, like new condition.",
    price: 200.00,
    category: "Furniture"
  },
  {
    title: "Mountain Bike - Trek X-Caliber",
    description: "Trek X-Caliber mountain bike with 29-inch wheels. Recently serviced, new tires. Perfect for trails and off-road adventures.",
    price: 650.00,
    category: "Sports"
  },
  {
    title: "Electric Lawn Mower",
    description: "Eco-friendly electric lawn mower with a 14-inch cutting width. Lightweight and easy to use. Great for small to medium yards.",
    price: 180.00,
    category: "Home & Garden"
  },
  {
    title: "iPhone 13 Pro - 256GB",
    description: "iPhone 13 Pro in Sierra Blue. 256GB storage, unlocked for all carriers. Includes original box and accessories. Screen protector applied since day one.",
    price: 799.99,
    category: "Electronics"
  },
  {
    title: "Designer Winter Coat",
    description: "Women's winter coat from a luxury brand. Size Small. Navy blue, down-filled, extremely warm. Only worn a few times.",
    price: 300.00,
    category: "Clothing"
  }
]

listings_data.each do |listing_data|
  user1.listings.create!(listing_data)
end

# Create some listings for user2
user2_listings = [
  {
    title: "Sony WH-1000XM4 Headphones",
    description: "Premium noise-cancelling wireless headphones. Excellent sound quality, comfortable for long use. Includes carrying case.",
    price: 280.00,
    category: "Electronics"
  },
  {
    title: "Yoga Mat & Block Set",
    description: "High-quality yoga mat with alignment lines, includes two foam blocks. Perfect for home workouts or studio practice.",
    price: 45.00,
    category: "Sports"
  },
  {
    title: "Vintage Record Player",
    description: "Fully functional vintage record player from the 1970s. Great sound quality, comes with a collection of 20 vinyl records.",
    price: 350.00,
    category: "Electronics"
  }
]

user2_listings.each do |listing_data|
  user2.listings.create!(listing_data)
end

# Create one listing for user3
user3.listings.create!(
  title: "Gaming Chair - Racing Style",
  description: "Ergonomic gaming chair with lumbar support and adjustable armrests. Red and black design. Very comfortable for long gaming sessions.",
  price: 220.00,
  category: "Furniture"
)

puts "Created #{Listing.count} listings"
puts "\n=== Seed Data Summary ==="
puts "Users created: #{User.count}"
puts "Listings created: #{Listing.count}"
puts "\nTest accounts:"
puts "Email: seller@example.com | Password: password123 (#{user1.listings.count} listings)"
puts "Email: john@example.com | Password: password123 (#{user2.listings.count} listings)"
puts "Email: test@example.com | Password: password123 (#{user3.listings.count} listing)"
puts "\nRun: rails db:seed"
