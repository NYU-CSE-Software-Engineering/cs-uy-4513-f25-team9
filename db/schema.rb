# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_12_01_004021) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "listings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.decimal "price"
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_listings_on_user_id"
  end

  create_table "purchases", force: :cascade do |t|
    t.bigint "buyer_id", null: false
    t.datetime "created_at", null: false
    t.bigint "listing_id", null: false
    t.decimal "price", precision: 8, scale: 2
    t.datetime "purchased_at"
    t.datetime "updated_at", null: false
    t.index ["buyer_id"], name: "index_purchases_on_buyer_id"
    t.index ["listing_id"], name: "index_purchases_on_listing_id"
  end

  create_table "reports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "listing_id", null: false
    t.text "reason"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["listing_id"], name: "index_reports_on_listing_id"
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.boolean "is_admin", default: false, null: false
    t.boolean "is_moderator", default: false, null: false
    t.string "name"
    t.string "password_digest"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "listings", "users"
  add_foreign_key "purchases", "listings"
  add_foreign_key "purchases", "users", column: "buyer_id"
  add_foreign_key "reports", "listings"
  add_foreign_key "reports", "users"
end
