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

ActiveRecord::Schema.define(version: 20150119072218) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "admins", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.text     "message"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "role"
    t.hstore   "related_attributes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree
  add_index "comments", ["user_id", "user_type"], name: "index_comments_on_user_id_and_user_type", using: :btree

  create_table "custom_comments", force: true do |t|
    t.text     "message"
    t.integer  "custom_commentable_id"
    t.string   "custom_commentable_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "role"
    t.hstore   "related_attributes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "custom_comments", ["custom_commentable_type", "custom_commentable_id"], name: "index_custom_comments_on_commentable_type_and_commentable_id", using: :btree
  add_index "custom_comments", ["user_id", "user_type"], name: "index_custom_comments_on_user_id_and_user_type", using: :btree

  create_table "letters", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "custom_comments_count", default: 0
  end

  create_table "main_models", force: true do |t|
    t.string   "title"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "note_custom_asso_names", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "comments_count", default: 0
  end

  create_table "post_custom_asso_names", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "comments_count", default: 0
  end

  create_table "topics", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
