require 'rails_helper'

RSpec.describe Report, type: :model do
  it 'belongs to a user' do
    assoc = described_class.reflect_on_association(:user)
    expect(assoc.macro).to eq(:belongs_to)
  end

  it 'belongs to a listing' do
    assoc = described_class.reflect_on_association(:listing)
    expect(assoc.macro).to eq(:belongs_to)
  end

  it "is invalid without a reason" do
    report = Report.new(reason: nil)
    expect(report).to_not be_valid
  end
end
