class Listing < ApplicationRecord
  belongs_to :user
  has_many :reports
  validates :title, presence: true

  scope :by_category, ->(category) { where(category: category) if category.present? }

  scope :by_price_range, ->(min_price: nil, max_price: nil) do
    query = all
    query = query.where('price >= ?', min_price) if min_price.present?
    query = query.where('price <= ?', max_price) if max_price.present?
    query
  end

  def self.available_categories
    distinct.order(:category).pluck(:category).compact
  end
end
