# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170917203337) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "company"
    t.string "first_name"
    t.string "surname"
    t.string "street_name"
    t.string "street_number"
    t.string "post_code"
    t.string "city"
    t.string "country"
    t.string "tax_no"
    t.datetime "birthday"
    t.bigint "order_id"
    t.integer "kind"
    t.index ["order_id"], name: "index_addresses_on_order_id"
  end

  create_table "order_lines", force: :cascade do |t|
    t.bigint "order_id"
    t.string "country_iso_code"
    t.integer "kind"
    t.index ["order_id"], name: "index_order_lines_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "number"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "paid_time"
    t.integer "value"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "payment_type"
    t.integer "kind"
    t.integer "status"
    t.string "transaction_reference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "order_id"
    t.index ["order_id"], name: "index_payments_on_order_id"
  end

  add_foreign_key "addresses", "orders"
  add_foreign_key "order_lines", "orders"
  add_foreign_key "payments", "orders"
end
