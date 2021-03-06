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

ActiveRecord::Schema.define(version: 20140417104528) do

  create_table "ad_clicks", force: true do |t|
    t.string  "uuid"
    t.string  "email"
    t.integer "click_times"
    t.integer "ad_id"
  end

  add_index "ad_clicks", ["ad_id"], name: "index_ad_clicks_on_ad_id"
  add_index "ad_clicks", ["email"], name: "index_ad_clicks_on_email"
  add_index "ad_clicks", ["uuid"], name: "index_ad_clicks_on_uuid"

  create_table "ads", force: true do |t|
    t.string "title"
    t.string "link"
    t.string "pic_link"
    t.string "bank_name"
    t.string "content"
  end

  create_table "category_table", force: true do |t|
    t.string   "category",                    null: false
    t.integer  "type",                        null: false
    t.string   "photo_path",                  null: false
    t.integer  "hidden",                      null: false
    t.integer  "order_no"
    t.string   "hash_key",                    null: false
    t.integer  "user_id"
    t.boolean  "is_delete",   default: false
    t.datetime "update_time",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "device_uuid"
  end

  add_index "category_table", ["device_uuid"], name: "index_category_table_on_device_uuid"
  add_index "category_table", ["hash_key"], name: "index_category_table_on_hash_key"
  add_index "category_table", ["user_id"], name: "index_category_table_on_user_id"

  create_table "currency_table", force: true do |t|
    t.string   "currency_code"
    t.decimal  "rate",            precision: 16, scale: 6,                 null: false
    t.string   "currency_remark"
    t.integer  "sequence_status",                                          null: false
    t.string   "flag_path",                                                null: false
    t.integer  "order_no"
    t.integer  "user_id"
    t.boolean  "is_delete",                                default: false
    t.datetime "update_time",                                              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "device_uuid"
  end

  add_index "currency_table", ["currency_code"], name: "index_currency_table_on_currency_code"
  add_index "currency_table", ["device_uuid"], name: "index_currency_table_on_device_uuid"
  add_index "currency_table", ["user_id"], name: "index_currency_table_on_user_id"

  create_table "devices", force: true do |t|
    t.integer  "user_id"
    t.string   "uuid"
    t.datetime "last_sync_time",  default: '1986-08-17 07:04:35'
    t.datetime "sync_start_time"
    t.boolean  "is_syncing",      default: false
  end

  add_index "devices", ["user_id"], name: "index_devices_on_user_id"
  add_index "devices", ["uuid"], name: "index_devices_on_uuid"

  create_table "messages", force: true do |t|
    t.integer  "user_id"
    t.text     "context"
    t.boolean  "is_read",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["user_id"], name: "index_messages_on_user_id"

  create_table "payee_table", force: true do |t|
    t.string   "payee_name",                  null: false
    t.integer  "hidden",                      null: false
    t.integer  "type"
    t.integer  "order_no"
    t.string   "hash_key",                    null: false
    t.boolean  "is_delete",   default: false
    t.integer  "user_id"
    t.datetime "update_time",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "device_uuid"
  end

  add_index "payee_table", ["device_uuid"], name: "index_payee_table_on_device_uuid"
  add_index "payee_table", ["hash_key"], name: "index_payee_table_on_hash_key"
  add_index "payee_table", ["user_id"], name: "index_payee_table_on_user_id"

  create_table "payment_table", force: true do |t|
    t.integer  "kind",                                                   null: false
    t.string   "payment_name",                                           null: false
    t.decimal  "total",         precision: 16, scale: 2,                 null: false
    t.string   "currency_code"
    t.decimal  "rate",          precision: 16, scale: 6
    t.integer  "out_total"
    t.integer  "hidden",                                                 null: false
    t.integer  "order_no"
    t.string   "hash_key",                                               null: false
    t.boolean  "is_delete",                              default: false
    t.integer  "user_id"
    t.datetime "update_time",                                            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "device_uuid"
  end

  add_index "payment_table", ["currency_code"], name: "index_payment_table_on_currency_code"
  add_index "payment_table", ["device_uuid"], name: "index_payment_table_on_device_uuid"
  add_index "payment_table", ["hash_key"], name: "index_payment_table_on_hash_key"
  add_index "payment_table", ["user_id"], name: "index_payment_table_on_user_id"

  create_table "period_table", force: true do |t|
    t.datetime "start_date",                  null: false
    t.datetime "end_date"
    t.datetime "update_date"
    t.integer  "period_type",                 null: false
    t.integer  "period_num",                  null: false
    t.integer  "order_no"
    t.string   "hash_key",                    null: false
    t.boolean  "is_delete",   default: false
    t.integer  "user_id"
    t.datetime "update_time",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "device_uuid"
  end

  add_index "period_table", ["device_uuid"], name: "index_period_table_on_device_uuid"
  add_index "period_table", ["hash_key"], name: "index_period_table_on_hash_key"
  add_index "period_table", ["user_id"], name: "index_period_table_on_user_id"

  create_table "pref_table", force: true do |t|
    t.string   "key",                         null: false
    t.string   "value"
    t.integer  "user_id"
    t.boolean  "is_delete",   default: false
    t.datetime "update_time",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "device_uuid"
  end

  add_index "pref_table", ["device_uuid"], name: "index_pref_table_on_device_uuid"
  add_index "pref_table", ["key"], name: "index_pref_table_on_key"
  add_index "pref_table", ["user_id"], name: "index_pref_table_on_user_id"

  create_table "project_table", force: true do |t|
    t.string   "project_name",                 null: false
    t.integer  "hidden",                       null: false
    t.integer  "order_no"
    t.string   "hash_key",                     null: false
    t.boolean  "is_delete",    default: false
    t.integer  "user_id"
    t.datetime "update_time",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "device_uuid"
  end

  add_index "project_table", ["device_uuid"], name: "index_project_table_on_device_uuid"
  add_index "project_table", ["hash_key"], name: "index_project_table_on_hash_key"
  add_index "project_table", ["user_id"], name: "index_project_table_on_user_id"

  create_table "record_table", force: true do |t|
    t.decimal  "mount",          precision: 16, scale: 2
    t.string   "category"
    t.string   "sub_category"
    t.datetime "date"
    t.string   "in_payment"
    t.string   "out_payment"
    t.text     "remark"
    t.string   "currency_code"
    t.decimal  "amount_to_main", precision: 16, scale: 2
    t.string   "period"
    t.string   "payee"
    t.string   "project"
    t.string   "fee"
    t.decimal  "in_amount",      precision: 16, scale: 2
    t.decimal  "out_amount",     precision: 16, scale: 2
    t.string   "in_currency"
    t.string   "out_currency"
    t.integer  "user_id"
    t.string   "hash_key"
    t.boolean  "is_delete",                               default: false
    t.datetime "update_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "device_uuid"
  end

  add_index "record_table", ["currency_code"], name: "index_record_table_on_currency_code"
  add_index "record_table", ["device_uuid"], name: "index_record_table_on_device_uuid"
  add_index "record_table", ["hash_key"], name: "index_record_table_on_hash_key"
  add_index "record_table", ["user_id"], name: "index_record_table_on_user_id"

  create_table "subcategory_table", force: true do |t|
    t.string   "id_category"
    t.string   "subcategory",                 null: false
    t.integer  "hidden",                      null: false
    t.integer  "order_no"
    t.string   "hash_key",                    null: false
    t.boolean  "is_delete",   default: false
    t.integer  "user_id"
    t.datetime "update_time",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "device_uuid"
  end

  add_index "subcategory_table", ["device_uuid"], name: "index_subcategory_table_on_device_uuid"
  add_index "subcategory_table", ["hash_key"], name: "index_subcategory_table_on_hash_key"
  add_index "subcategory_table", ["user_id"], name: "index_subcategory_table_on_user_id"

  create_table "user_share_payment_relations", force: true do |t|
    t.integer  "share_user_id",                    null: false
    t.integer  "owner_user_id",                    null: false
    t.string   "payment_hash_key",                 null: false
    t.boolean  "is_approved",      default: false
    t.string   "token"
    t.integer  "permission",                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_share_payment_relations", ["is_approved"], name: "index_user_share_payment_relations_on_is_approved"
  add_index "user_share_payment_relations", ["owner_user_id"], name: "index_user_share_payment_relations_on_owner_user_id"
  add_index "user_share_payment_relations", ["payment_hash_key"], name: "index_user_share_payment_relations_on_payment_hash_key"
  add_index "user_share_payment_relations", ["share_user_id"], name: "index_user_share_payment_relations_on_share_user_id"
  add_index "user_share_payment_relations", ["token"], name: "index_user_share_payment_relations_on_token"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "sync_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_syncing",    default: false
    t.string   "uid"
    t.string   "provider"
    t.string   "refresh_token"
    t.string   "access_token"
    t.datetime "expires"
    t.boolean  "is_pro",        default: false
    t.datetime "expire_date"
    t.string   "customer_id"
  end

  add_index "users", ["uid"], name: "index_users_on_uid"

end
