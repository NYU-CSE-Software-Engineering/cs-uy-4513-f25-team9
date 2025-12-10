class CreateConversations < ActiveRecord::Migration[8.1]
  def change
    create_table :conversations do |t|
      t.references :buyer, null: false, foreign_key: { to_table: :users }
      t.references :seller, null: false, foreign_key: { to_table: :users }
      t.references :listing, null: false, foreign_key: true

      t.timestamps
    end
  end
end
