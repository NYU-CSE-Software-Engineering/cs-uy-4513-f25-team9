# app/models/user_report.rb - User report record model
class UserReport < ApplicationRecord
    # Associate reported user and reporter
    belongs_to :reported_user, class_name: 'User'
    belongs_to :reporter, class_name: 'User'
    
    # Status fields: unprocessed/processed
    enum status: { unprocessed: 'unprocessed', processed: 'processed' }, _default: 'unprocessed'
    
    # Necessary field validations
    validates :reported_user_id, :reporter_id, :reason, presence: true
  end
  
  # app/models/user.rb - Extended user model
  class User < ApplicationRecord
    # New user status fields: active/banned
    enum status: { active: 'active', banned: 'banned' }, _default: 'active'
    
    # Associate user report records (as the reported party)
    has_many :user_reports, foreign_key: 'reported_user_id'
    
    # New ban-related fields
    attribute :ban_reason, :string
    attribute :banned_until, :datetime # Temporary ban end time (nil for permanent ban)
  end
  
  # app/models/moderation_log.rb - Moderation operation log model
  class ModerationLog < ApplicationRecord
    # Operation types: product_deletion/user_ban
    enum operation_type: { product_deletion: 'product_deletion', user_ban: 'user_ban' }
    
    # Associate the moderator who performed the operation and the target user/product
    belongs_to :moderator, class_name: 'User'
    belongs_to :target_user, class_name: 'User', optional: true
    belongs_to :target_listing, class_name: 'Listing', optional: true
  end