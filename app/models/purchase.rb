class Purchase < ApplicationRecord
  belongs_to :buyer, class_name: 'User'
  belongs_to :listing

  validates :buyer, presence: true
  validates :listing, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :listing_id, uniqueness: true
end