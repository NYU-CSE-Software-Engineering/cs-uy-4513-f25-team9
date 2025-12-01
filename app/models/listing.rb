class Listing < ApplicationRecord
  belongs_to :user
  has_many :reports
  validates :title, presence: true

  # Filter by category if present
  scope :by_category, ->(category) { where(category: category) if category.present? }

  # Filter by price range with optional min/max bounds
  scope :by_price_range, lambda { |min_price: nil, max_price: nil|
    scope = all
    scope = scope.where('price >= ?', min_price) if min_price.present?
    scope = scope.where('price <= ?', max_price) if max_price.present?
    scope
  }

  # Search in title and description (case-insensitive, ILIKE for PostgreSQL)
  scope :by_search, lambda { |query|
    return all unless query.present?
    
    where('LOWER(title) ILIKE :query OR LOWER(description) ILIKE :query',
          query: "%#{query.downcase}%")
  }

  # Fetch available categories from database (distinct and sorted)
  def self.available_categories
    distinct.order(:category).pluck(:category).compact
  end
end
