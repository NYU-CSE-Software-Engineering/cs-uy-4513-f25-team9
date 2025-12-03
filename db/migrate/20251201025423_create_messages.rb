# module ThryftMigrations
  class CreateMessagesMigration < ActiveRecord::Migration[8.1]
    def change
      create_table :messages do |t|
        t.text :content
        t.boolean :read
        t.references :user, null: false, foreign_key: true
        t.references :conversation, null: false, foreign_key: true

        t.timestamps
      end
    end
  end
# end
