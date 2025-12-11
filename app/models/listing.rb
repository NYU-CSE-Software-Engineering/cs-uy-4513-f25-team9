class Listing < ApplicationRecord
  belongs_to :user
  has_many :reports, dependent: :destroy
  has_many :interests, dependent: :destroy
  validates :title, presence: true

  # Filter by category if present
  scope :by_category, ->(category) { where(category: category) if category.present? }

  # Exclude listings owned by a given user
  scope :not_owned_by, ->(user) { user.present? ? where.not(user_id: user.id) : all }

  # Exclude listings that have already been purchased
  scope :not_purchased, -> { where.not(id: Purchase.select(:listing_id)) }

  # Exclude listings by ids
  scope :excluding_ids, ->(ids) { ids.present? ? where.not(id: ids) : all }

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

  # Sort by various fields with sensible defaults
  scope :by_sort, lambda { |sort|
    case sort
    when 'price_asc' then order(price: :asc)
    when 'price_desc' then order(price: :desc)
    else order(created_at: :desc)  # Default to newest
    end
  }

  # Fetch available categories from database (distinct and sorted)
  def self.available_categories
    distinct.order(:category).pluck(:category).compact
  end
end