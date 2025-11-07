class Listing < ApplicationRecord
  belongs_to :user
  has_many :reports
  validates :title, presence: true
end
