class AddCategoryToListings < ActiveRecord::Migration[8.1]
  def change
    add_column :listings, :category, :string
    add_index :listings, :category
  end
end
