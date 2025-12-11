class User < ApplicationRecord
  has_secure_password

  has_many :listings, dependent: :destroy
  has_many :purchases, foreign_key: :buyer_id, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :interests, foreign_key: :buyer_id, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  # Moderator helper methods
  def moderator?
    is_moderator
  end

  def admin?
    is_admin
  end

  def can_delete_user?(target_user)
    return false unless moderator?
    # Moderators can delete non-moderators
    return true unless target_user.moderator?
    # Only admins can delete other moderators
    admin?
  end

  def user_type
    return 'Admin' if admin?
    return 'Moderator' if moderator?
    'User'
  end

  def reported_listings_count
    Report.joins(:listing).where(listings: { user_id: id }).count
  end
end
