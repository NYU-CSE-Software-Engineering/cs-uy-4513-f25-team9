class Interest < ApplicationRecord
  STATES = %w[liked passed].freeze

  belongs_to :buyer, class_name: 'User'
  belongs_to :listing

  validates :buyer, :listing, :state, presence: true
  validates :state, inclusion: { in: STATES }
  validates :buyer_id, uniqueness: { scope: :listing_id }

  scope :liked,  -> { where(state: 'liked') }
  scope :passed, -> { where(state: 'passed') }

  def liked?  = state == 'liked'
  def passed? = state == 'passed'
end
