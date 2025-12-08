class Conversation < ApplicationRecord
  belongs_to :buyer, class_name: "User"
  belongs_to :seller, class_name: "User"
  belongs_to :listing
  has_many :messages

  validates :buyer, presence: true
  validates :seller, presence: true
  validates :listing, presence: true
end
