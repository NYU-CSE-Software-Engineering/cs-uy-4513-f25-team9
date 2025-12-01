module ThryftMigrations
  class CreatePurchasesMigration < ActiveRecord::Migration[8.1]
    def change
      create_table :purchases do |t|
        t.references :buyer, null: false, foreign_key: { to_table: :users }
        t.references :listing, null: false, foreign_key: true
        t.decimal :price, precision: 8, scale: 2
        t.datetime :purchased_at

        t.timestamps
      end
    end
  end
end
