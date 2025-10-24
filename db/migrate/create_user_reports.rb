# db/migrate/[timestamp]_create_user_reports.rb
class CreateUserReports < ActiveRecord::Migration[6.1]
    def change
      create_table :user_reports do |t|
        t.references :reported_user, null: false, foreign_key: { to_table: :users }
        t.references :reporter, null: false, foreign_key: { to_table: :users }
        t.text :reason, null: false
        t.string :status, default: 'unprocessed'
        t.timestamps
      end
    end
  end
  
  # db/migrate/[timestamp]_add_ban_fields_to_users.rb
  class AddBanFieldsToUsers < ActiveRecord::Migration[6.1]
    def change
      add_column :users, :status, :string, default: 'active'
      add_column :users, :ban_reason, :string
      add_column :users, :banned_until, :datetime
    end
  end
  
  # db/migrate/[timestamp]_create_moderation_logs.rb
  class CreateModerationLogs < ActiveRecord::Migration[6.1]
    def change
      create_table :moderation_logs do |t|
        t.references :moderator, null: false, foreign_key: { to_table: :users }
        t.string :operation_type, null: false
        t.references :target_user, foreign_key: { to_table: :users }, null: true
        t.references :target_listing, foreign_key: true, null: true
        t.text :operation_notes
        t.timestamps
      end
    end
  end