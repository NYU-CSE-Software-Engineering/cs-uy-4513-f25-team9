class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation

  validates :content, presence: true
  validates :user, presence: true
  validates :conversation, presence: true

  after_initialize :set_default_read, if: :new_record?

  private

  def set_default_read
    self.read ||= false
  end
end
