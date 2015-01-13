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

ActiveRecord::Schema.define(version: 20150113045831) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "admins", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.string   "massage"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["user_id", "user_type"], name: "index_comments_on_user_id_and_user_type", using: :btree

  create_table "onebox_core_admins", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "onebox_core_admins", ["email"], name: "index_onebox_core_admins_on_email", unique: true, using: :btree
  add_index "onebox_core_admins", ["reset_password_token"], name: "index_onebox_core_admins_on_reset_password_token", unique: true, using: :btree

  create_table "onebox_core_attachments", force: true do |t|
    t.string   "file_name"
    t.string   "attachment_type"
    t.string   "file_type"
    t.integer  "file_size"
    t.string   "alt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "file_processing"
    t.json     "image_sizes",     default: {}, null: false
  end

  create_table "onebox_core_categories", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "icon_name"
    t.hstore   "icon_sizes"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
    t.integer  "product_quantity", default: 0
  end

  create_table "onebox_core_categories_products", id: false, force: true do |t|
    t.integer "category_id"
    t.integer "product_id"
  end

  create_table "onebox_core_line_items", force: true do |t|
    t.integer  "variant_id"
    t.integer  "order_id"
    t.integer  "price_satangs", default: 0
    t.integer  "quantity",      default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "onebox_core_line_items", ["order_id"], name: "index_onebox_core_line_items_on_order_id", using: :btree
  add_index "onebox_core_line_items", ["variant_id"], name: "index_onebox_core_line_items_on_variant_id", using: :btree

  create_table "onebox_core_option_types", force: true do |t|
    t.string   "name"
    t.string   "display_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "onebox_core_option_values", force: true do |t|
    t.integer  "option_type_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "onebox_core_option_values", ["option_type_id"], name: "index_onebox_core_option_values_on_option_type_id", using: :btree

  create_table "onebox_core_option_values_variants", id: false, force: true do |t|
    t.integer "variant_id"
    t.integer "option_value_id"
  end

  create_table "onebox_core_ordered_addresses", force: true do |t|
    t.string   "address_no"
    t.string   "building"
    t.string   "street"
    t.string   "sub_district"
    t.string   "district"
    t.string   "province"
    t.string   "zipcode"
    t.integer  "country_code"
    t.string   "country_name"
    t.string   "mobile_number"
    t.string   "road"
    t.string   "name"
    t.text     "address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "receiver_name"
  end

  create_table "onebox_core_orders", force: true do |t|
    t.integer  "ship_address_id"
    t.integer  "bill_address_id"
    t.string   "order_number"
    t.integer  "order_status_id"
    t.integer  "items_price_satangs",        default: 0
    t.integer  "total_price_satangs",        default: 0
    t.integer  "shipping_option_id"
    t.integer  "shipping_cost_satangs",      default: 0
    t.string   "shipping_tacking"
    t.string   "shipping_type"
    t.string   "email"
    t.string   "guest_token"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "payment_status_id"
    t.integer  "payment_option_id"
    t.string   "payment_name"
    t.float    "payment_fee_percent",        default: 0.0
    t.integer  "payment_fee_cost_satangs",   default: 0
    t.string   "payment_type"
    t.integer  "payment_total_cost_satangs", default: 0
    t.string   "tracking_number"
    t.datetime "returned_stocks_at"
  end

  create_table "onebox_core_payment_options", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.float    "fee_percent",      default: 0.0
    t.integer  "fee_cost_satangs", default: 0
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "onebox_core_products", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.boolean  "is_online",   default: true
  end

  add_index "onebox_core_products", ["deleted_at"], name: "index_onebox_core_products_on_deleted_at", using: :btree

  create_table "onebox_core_shipping_options", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "shipping_cost_satangs", default: 0
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "onebox_core_states", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.string   "slug"
  end

  create_table "onebox_core_statuses", force: true do |t|
    t.string   "name"
    t.integer  "state_id"
    t.boolean  "is_default", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.string   "slug"
  end

  create_table "onebox_core_stocks", force: true do |t|
    t.integer  "variant_id"
    t.integer  "warehouse_id"
    t.integer  "quantity",     default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "onebox_core_stocks", ["variant_id"], name: "index_onebox_core_stocks_on_variant_id", using: :btree
  add_index "onebox_core_stocks", ["warehouse_id"], name: "index_onebox_core_stocks_on_warehouse_id", using: :btree

  create_table "onebox_core_variants", force: true do |t|
    t.string   "sku"
    t.boolean  "is_master",     default: false
    t.integer  "price_satangs", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.datetime "deleted_at"
  end

  add_index "onebox_core_variants", ["deleted_at"], name: "index_onebox_core_variants_on_deleted_at", using: :btree
  add_index "onebox_core_variants", ["product_id"], name: "index_onebox_core_variants_on_product_id", using: :btree

  create_table "onebox_core_variants_match_photos", force: true do |t|
    t.integer "variant_id"
    t.integer "variant_photo_id"
    t.integer "position"
    t.integer "product_id"
  end

  add_index "onebox_core_variants_match_photos", ["product_id"], name: "index_onebox_core_variants_match_photos_on_product_id", using: :btree
  add_index "onebox_core_variants_match_photos", ["variant_id", "variant_photo_id"], name: "index_onebox_core_variants_match_photos_on_variant_and_photo", unique: true, using: :btree
  add_index "onebox_core_variants_match_photos", ["variant_id"], name: "index_onebox_core_variants_match_photos_on_variant_id", using: :btree
  add_index "onebox_core_variants_match_photos", ["variant_photo_id"], name: "index_onebox_core_variants_match_photos_on_variant_photo_id", using: :btree

  create_table "onebox_core_warehouses", force: true do |t|
    t.boolean  "actived",    default: true
    t.string   "name"
    t.boolean  "is_default", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "versions", force: true do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
    t.string   "when_state"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
