module ThryftMigrations
  class CreateReports < ActiveRecord::Migration[8.1]
    def change
      create_table :reports do |t|
        t.text :reason
        t.references :user, null: false, foreign_key: true
        t.references :listing, null: false, foreign_key: true

        t.timestamps
      end
    end
  end
end
