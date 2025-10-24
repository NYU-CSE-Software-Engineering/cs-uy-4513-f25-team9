class CreateListings < ActiveRecord::Migration[8.0]
  def change
    create_table :listings do |t|
      t.string :name
      t.string :category
      t.integer :price

      t.timestamps
    end
  end
end
