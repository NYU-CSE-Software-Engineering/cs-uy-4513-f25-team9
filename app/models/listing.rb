class Listing < ApplicationRecord
  belongs_to :user
  has_many :reports
  validates :title, presence: true

  scope :by_category, ->(category) { where(category: category) if category.present? }

  def self.available_categories
    distinct.order(:category).pluck(:category).compact
  end
end
