class CreatePurchases < ActiveRecord::Migration[8.1]
  def change
    create_table :purchases do |t|
      t.references :buyer, null: false, foreign_key: { to_table: :users }
      t.references :listing, null: false, foreign_key: true
      t.decimal :price, precision: 10, scale: 2, null: false
      t.datetime :purchased_at, null: false

      t.timestamps
    end
    
    add_index :purchases, [:buyer_id, :purchased_at]
  end
end
