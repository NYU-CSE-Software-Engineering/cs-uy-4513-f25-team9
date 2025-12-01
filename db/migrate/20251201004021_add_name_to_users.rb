module ThryftMigrations
  class AddNameToUsersMigration < ActiveRecord::Migration[8.1]
    def change
      add_column :users, :name, :string
    end
  end
end
