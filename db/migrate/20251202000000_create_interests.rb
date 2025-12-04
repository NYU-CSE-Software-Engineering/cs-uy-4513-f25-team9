class CreateInterests < ActiveRecord::Migration[8.1]
  def change
    create_table :interests do |t|
      t.references :buyer, null: false, foreign_key: { to_table: :users }
      t.references :listing, null: false, foreign_key: true
      t.string :state, null: false

      t.timestamps
    end

    add_index :interests, [:buyer_id, :listing_id], unique: true
  end
end
