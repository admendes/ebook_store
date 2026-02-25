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

ActiveRecord::Schema[8.1].define(version: 2026_02_25_102719) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "ebook_tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "ebook_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "updated_at", null: false
    t.index ["ebook_id"], name: "index_ebook_tags_on_ebook_id"
    t.index ["tag_id"], name: "index_ebook_tags_on_tag_id"
  end

  create_table "ebooks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "page_visit_count", default: 0, null: false
    t.integer "preview_view_count", default: 0, null: false
    t.decimal "price", precision: 10, scale: 2
    t.integer "purchase_count", default: 0, null: false
    t.string "status", default: "draft", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_ebooks_on_user_id"
  end

  create_table "purchases", force: :cascade do |t|
    t.decimal "amount"
    t.integer "buyer_id"
    t.datetime "created_at", null: false
    t.bigint "ebook_id", null: false
    t.decimal "seller_commission"
    t.datetime "updated_at", null: false
    t.index ["ebook_id"], name: "index_purchases_on_ebook_id"
  end

  create_table "tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.decimal "balance", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.string "email"
    t.datetime "last_password_change"
    t.string "name"
    t.string "password_digest"
    t.string "role", default: "buyer", null: false
    t.string "status", default: "enabled", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "visitors", force: :cascade do |t|
    t.string "browser"
    t.datetime "created_at", null: false
    t.bigint "ebook_id", null: false
    t.string "ip_address"
    t.string "location"
    t.datetime "updated_at", null: false
    t.index ["ebook_id"], name: "index_visitors_on_ebook_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "ebook_tags", "ebooks"
  add_foreign_key "ebook_tags", "tags"
  add_foreign_key "ebooks", "users"
  add_foreign_key "purchases", "ebooks"
  add_foreign_key "visitors", "ebooks"
end
