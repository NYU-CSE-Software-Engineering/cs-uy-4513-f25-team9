require 'rails_helper'

RSpec.describe Report, type: :model do
  let(:user) { User.create!(email: 'test@example.com') }
  let(:listing) { Listing.create!(title: 'Test listing', price: 10.0, user: user) }

  it 'belongs to a user' do
    assoc = described_class.reflect_on_association(:user)
    expect(assoc.macro).to eq(:belongs_to)
  end

  it 'belongs to a listing' do
    assoc = described_class.reflect_on_association(:listing)
    expect(assoc.macro).to eq(:belongs_to)
  end

  it 'is invalid without a reason' do
    report = Report.new(user: user, listing: listing, reason: nil)
    report.validate
    expect(report.errors[:reason]).to include("can't be blank")
  end
end
