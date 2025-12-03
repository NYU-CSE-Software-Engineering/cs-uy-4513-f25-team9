class Purchase < ApplicationRecord
  belongs_to :buyer, class_name: 'User'
  belongs_to :listing, optional: true  # Optional because listing might be deleted

  validates :buyer, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :purchased_at, presence: true

  # Scope to order by purchased_at descending (most recent first)
  scope :recent_first, -> { order(purchased_at: :desc) }

  # Get listing title with fallback for deleted listings
  def listing_title
    listing&.title || 'Listing no longer available'
  end

  # Get formatted price
  def formatted_price
    "$#{format('%.2f', price)}"
  end

  # Get formatted purchase date
  def formatted_date
    purchased_at.to_date.to_s
  end
end