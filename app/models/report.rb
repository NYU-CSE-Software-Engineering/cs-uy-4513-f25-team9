class Report < ApplicationRecord
  belongs_to :user
  belongs_to :listing

  validates :user, presence: true
  validates :listing, presence: true
  validates :reason, presence: true, length: { maximum: 500 }
  validates :user_id, uniqueness: { scope: :listing_id, message: "has already reported this listing" }
end