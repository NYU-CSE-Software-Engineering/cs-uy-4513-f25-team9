class ModifyReportsListingForeignKey < ActiveRecord::Migration[8.1]
  def up
    # Remove existing foreign key
    remove_foreign_key :reports, :listings
    
    # Add foreign key with cascade delete
    add_foreign_key :reports, :listings, on_delete: :cascade
  end

  def down
    # Remove cascade foreign key
    remove_foreign_key :reports, :listings
    
    # Restore original foreign key (without cascade)
    add_foreign_key :reports, :listings
  end
end
