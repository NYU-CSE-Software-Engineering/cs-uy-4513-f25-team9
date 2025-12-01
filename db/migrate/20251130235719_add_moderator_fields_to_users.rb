module ThryftMigrations
  class AddModeratorFieldsToUsersMigration < ActiveRecord::Migration[8.1]
    def change
      add_column :users, :is_moderator, :boolean, default: false, null: false
      add_column :users, :is_admin, :boolean, default: false, null: false
    end
  end
end
