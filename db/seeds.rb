# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require 'open-uri'

puts "Cleaning database..."
Listing.destroy_all
User.destroy_all

puts "Creating users..."
users = []
5.times do |i|
  users << User.create!(
    email: "user#{i+1}@example.com",
    password: "password123",
    password_confirmation: "password123",
    name: "User #{i+1}"
  )
end

puts "Creating listings with images..."

# Sample product data with image URLs from placeholder services
listings_data = [
  {
    title: "Vintage Leather Jacket",
    description: "Classic brown leather jacket in excellent condition. Size M. Perfect for fall weather.",
    price: 85.00,
    category: "Apparel",
    image_url: "https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400"
  },
  {
    title: "iPhone 12 Pro",
    description: "Gently used iPhone 12 Pro, 128GB, Space Gray. Includes charger and case.",
    price: 599.99,
    category: "Electronics",
    image_url: "https://images.unsplash.com/photo-1591337676887-a217a6970a8a?w=400"
  },
  {
    title: "IKEA Desk - White",
    description: "Modern white desk, perfect for home office. Some minor scratches but fully functional.",
    price: 45.00,
    category: "Furniture",
    image_url: "https://images.unsplash.com/photo-1518455027359-f3f8164ba6bd?w=400"
  },
  {
    title: "Calculus Textbook",
    description: "Calculus: Early Transcendentals, 8th Edition. Like new condition, minimal highlighting.",
    price: 35.00,
    category: "Books",
    image_url: "https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400"
  },
  {
    title: "Coffee Maker - Keurig",
    description: "Single-serve Keurig coffee maker. Works perfectly, includes 10 K-cups.",
    price: 55.00,
    category: "Kitchen",
    image_url: "https://images.unsplash.com/photo-1517668808822-9ebb02f2a0e6?w=400"
  },
  {
    title: "Nike Running Shoes",
    description: "Men's Nike Air Zoom Pegasus, size 10. Worn only a few times.",
    price: 70.00,
    category: "Apparel",
    image_url: "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400"
  },
  {
    title: "MacBook Air 2020",
    description: "MacBook Air M1, 8GB RAM, 256GB SSD. Excellent condition with original box.",
    price: 750.00,
    category: "Electronics",
    image_url: "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400"
  },
  {
    title: "Wooden Bookshelf",
    description: "5-tier wooden bookshelf, dark brown finish. Sturdy and spacious.",
    price: 60.00,
    category: "Furniture",
    image_url: "https://images.unsplash.com/photo-1594620302200-9a762244a156?w=400"
  },
  {
    title: "Psychology Textbook Bundle",
    description: "3 psychology textbooks: Intro to Psych, Abnormal Psych, and Social Psych.",
    price: 80.00,
    category: "Books",
    image_url: "https://images.unsplash.com/photo-1589998059171-988d887df646?w=400"
  },
  {
    title: "Instant Pot 6 Qt",
    description: "6-quart Instant Pot pressure cooker. Used once, practically new.",
    price: 65.00,
    category: "Kitchen",
    image_url: "https://images.unsplash.com/photo-1585515320310-259814833e62?w=400"
  }
]

listings_data.each_with_index do |data, index|
  listing = users[index % users.length].listings.create!(
    title: data[:title],
    description: data[:description],
    price: data[:price],
    category: data[:category]
  )
  
  # Attach image from URL
  begin
    file = URI.open(data[:image_url])
    listing.image.attach(io: file, filename: "#{data[:title].parameterize}.jpg")
    puts "✓ Created: #{listing.title}"
  rescue => e
    puts "✗ Error attaching image for #{listing.title}: #{e.message}"
  end
end

puts "\nSeeding completed!"
puts "Created #{User.count} users and #{Listing.count} listings"
