# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20131023140456) do

  create_table "category_table", force: true do |t|
    t.string   "category"
    t.integer  "type"
    t.string   "photo"
    t.boolean  "hidden"
    t.integer  "order_no"
    t.string   "hash_key"
    t.integer  "user_id"
    t.boolean  "is_delete"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "category_table", ["hash_key"], name: "index_category_table_on_hash_key", using: :btree

  create_table "currency_table", force: true do |t|
    t.string   "currency_code"
    t.float    "rate"
    t.string   "currency_remark"
    t.integer  "sequence_status"
    t.string   "pic"
    t.integer  "order_no"
    t.integer  "user_id"
    t.boolean  "is_delete"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "currency_table", ["currency_code"], name: "index_currency_table_on_currency_code", using: :btree

  create_table "devices", force: true do |t|
    t.integer  "user_id"
    t.string   "uuid"
    t.datetime "last_sync_time",  default: '1986-06-08 05:53:20'
    t.datetime "sync_start_time"
  end

  add_index "devices", ["user_id"], name: "index_devices_on_user_id", using: :btree
  add_index "devices", ["uuid"], name: "index_devices_on_uuid", using: :btree

  create_table "payee_table", force: true do |t|
    t.string   "payee_name"
    t.boolean  "hidden"
    t.integer  "type"
    t.integer  "order_no"
    t.string   "hash_key"
    t.boolean  "is_delete"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payee_table", ["hash_key"], name: "index_payee_table_on_hash_key", using: :btree

  create_table "payment_table", force: true do |t|
    t.integer  "kind"
    t.string   "payment_name"
    t.float    "total"
    t.string   "currency_code"
    t.float    "rate"
    t.boolean  "hidden"
    t.integer  "order_no"
    t.string   "hash_key"
    t.boolean  "is_delete"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payment_table", ["hash_key"], name: "index_payment_table_on_hash_key", using: :btree

  create_table "period_table", force: true do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "update_date"
    t.integer  "peroid_type"
    t.integer  "preriod_num"
    t.integer  "order_no"
    t.string   "hash_key"
    t.boolean  "is_delete"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "period_table", ["hash_key"], name: "index_period_table_on_hash_key", using: :btree

  create_table "pref_table", force: true do |t|
    t.string   "key"
    t.string   "value"
    t.integer  "user_id"
    t.boolean  "is_delete"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_table", force: true do |t|
    t.string   "project_name"
    t.boolean  "hidden"
    t.integer  "order_no"
    t.string   "hash_key"
    t.boolean  "is_delete"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_table", ["hash_key"], name: "index_project_table_on_hash_key", using: :btree

  create_table "record_table", force: true do |t|
    t.string   "project_name"
    t.float    "amount"
    t.integer  "category_id"
    t.integer  "subcategory_id"
    t.string   "category_hash_key"
    t.string   "subcategory_hash_key"
    t.datetime "date"
    t.boolean  "in_payment"
    t.boolean  "out_payment"
    t.text     "remark"
    t.string   "currency_code"
    t.float    "amount_to_main"
    t.integer  "period_id"
    t.integer  "payee_id"
    t.integer  "project_id"
    t.string   "hash_key"
    t.boolean  "is_delete",            default: false
    t.float    "in_amount"
    t.float    "out_amount"
    t.string   "in_currency"
    t.string   "out_currency"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "record_table", ["hash_key"], name: "index_record_table_on_hash_key", using: :btree
  add_index "record_table", ["user_id"], name: "index_record_table_on_user_id", using: :btree

  create_table "subcategory_table", force: true do |t|
    t.integer  "category_id"
    t.string   "subcategory"
    t.boolean  "hidden"
    t.integer  "order_no"
    t.string   "hash_key"
    t.string   "category_hash_key"
    t.boolean  "is_delete"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "sync_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
