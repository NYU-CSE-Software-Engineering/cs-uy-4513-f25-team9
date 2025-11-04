class CreateListings < ActiveRecord::Migration[8.1]
  def change
    create_table :listings do |t|
      t.string :title, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.string :status, default: 'active'

      t.timestamps
    end
    
    add_index :listings, :status
  end
end
