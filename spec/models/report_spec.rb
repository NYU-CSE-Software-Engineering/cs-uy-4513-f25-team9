require 'rails_helper'

RSpec.describe Report, type: :model do
  let(:user) { User.create!(email: 'test@example.com', password: 'password123') }
  let(:listing) { Listing.create!(title: 'Scam Listing', price: 100, user: user) }

  describe "associations" do
    it 'belongs to a user' do
      assoc = described_class.reflect_on_association(:user)
      expect(assoc.macro).to eq(:belongs_to)
    end

    it 'belongs to a listing' do
      assoc = described_class.reflect_on_association(:listing)
      expect(assoc.macro).to eq(:belongs_to)
    end
  end

  describe "validations" do
    it 'is invalid without a reason' do
      report = Report.new(user: user, listing: listing, reason: nil)
      report.validate
      expect(report.errors[:reason]).to include("can't be blank")
    end

    it 'is invalid if reason is too long' do
      long_reason = 'a' * 501
      report = Report.new(user: user, listing: listing, reason: long_reason)
      report.validate
      expect(report.errors[:reason]).to include("is too long (maximum is 500 characters)")
    end

    it 'is valid with all proper attributes' do
      report = Report.new(user: user, listing: listing, reason: 'Fraudulent')
      expect(report).to be_valid
    end
  end
end
