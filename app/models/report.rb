class Report < ApplicationRecord
  belongs_to :user
  belongs_to :listing

  validates :reason, presence: true
end
