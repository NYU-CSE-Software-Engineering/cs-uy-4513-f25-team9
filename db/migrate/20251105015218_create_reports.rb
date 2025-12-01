class CreateReports < ActiveRecord::Migration[8.1]
  def change
    create_table :reports do |t|
      t.references :user, null: false, foreign_key: true
      t.references :listing, null: false, foreign_key: true
      t.text :reason

      t.timestamps
    end
  end
end
