class Conversation < ApplicationRecord
  belongs_to :buyer, class_name: "User"
  belongs_to :seller, class_name: "User"
  belongs_to :listing
  has_many :messages

  validates :buyer, presence: true
  validates :seller, presence: true
  validates :listing, presence: true
  validate :buyer_and_seller_are_different

  private

  def buyer_and_seller_are_different
    if buyer_id == seller_id
      errors.add(:seller, "Buyer and seller cannot be the same user")
    end
  end
end
