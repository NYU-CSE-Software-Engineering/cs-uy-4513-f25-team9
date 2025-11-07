require 'rails_helper'

RSpec.describe Listing, type: :model do
  let(:user) { User.create!(email: 'seller@example.com', password: 'pw123456') }

  it "belongs to a user" do
    assoc = described_class.reflect_on_association(:user)
    expect(assoc.macro).to eq(:belongs_to)
  end

  it "is invalid without a title" do
    listing = Listing.new(title: nil, price: 100, user: user)
    listing.validate
    expect(listing.errors[:title]).to include("can't be blank")
  end

  it "is valid with title, price, and user" do
    listing = Listing.new(title: "Scam", price: 999, user: user)
    expect(listing).to be_valid
  end
end