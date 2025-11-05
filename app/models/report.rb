class Report < ApplicationRecord
  belongs_to :user
  belongs_to :listing

  validates :reason, presence: true, length: { maximum: 500 }
end
