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

ActiveRecord::Schema.define(version: 20180303150106) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "imports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "body"
    t.integer "error"
    t.string "datafile"
  end

  create_table "items", force: :cascade do |t|
    t.string "sku"
    t.integer "supplier_id"
    t.string "sup_code"
    t.string "add1"
    t.string "add2"
    t.string "add3"
    t.string "add4"
    t.string "add5"
    t.string "add6"
    t.float "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sku"], name: "index_items_on_sku"
    t.index ["sup_code"], name: "index_items_on_sup_code"
    t.index ["supplier_id"], name: "index_items_on_supplier_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "sup_code"
    t.string "sup_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sup_code"], name: "index_suppliers_on_sup_code"
  end

end
