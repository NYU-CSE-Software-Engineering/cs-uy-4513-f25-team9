class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation

  validates :content, presence: true, length: { maximum: 5000 }
  validates :user, presence: true
  validates :conversation, presence: true

  after_initialize :set_default_read, if: :new_record?

  scope :unread_for, ->(user) {
    joins(:conversation)
      .where("conversations.buyer_id = ? OR conversations.seller_id = ?", user.id, user.id)
      .where.not(user: user)
      .where(read: false)
  }

  def self.unread_count_for(user)
    unread_for(user).count
  end

  private

  def set_default_read
    self.read ||= false
  end
end
