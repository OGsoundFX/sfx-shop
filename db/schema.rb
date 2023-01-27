# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_01_27_153948) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "annoucements", force: :cascade do |t|
    t.string "title"
    t.string "content"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "carts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "items", default: [], array: true
    t.integer "sinlge_tracks", default: [], array: true
    t.integer "collections", default: [], array: true
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "collection_categories", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "price_cents", default: 0, null: false
    t.integer "points"
  end

  create_table "collections", force: :cascade do |t|
    t.integer "total_points"
    t.integer "tracks", default: [], array: true
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "price_cents", default: 0, null: false
    t.string "title"
    t.boolean "purchased", default: false
    t.bigint "template_collection_id"
    t.index ["template_collection_id"], name: "index_collections_on_template_collection_id"
    t.index ["user_id"], name: "index_collections_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "product_link"
    t.string "sku"
    t.string "status"
    t.integer "amount_cents", default: 0, null: false
    t.string "checkout_session_id"
    t.bigint "user_id", null: false
    t.bigint "sfx_pack_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "multiple", default: false
    t.integer "packs", default: [], array: true
    t.string "coupon"
    t.integer "amount_paid_cents", default: 0, null: false
    t.string "amount_paid_currency", default: "USD", null: false
    t.json "sales", default: {}
    t.boolean "sale", default: false
    t.integer "tracks", default: [], array: true
    t.integer "collections", default: [], array: true
    t.index ["sfx_pack_id"], name: "index_orders_on_sfx_pack_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "sales", force: :cascade do |t|
    t.string "title"
    t.integer "percentage"
    t.date "start_date"
    t.date "end_date"
    t.integer "packs", default: [], array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sfx_packs", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "category"
    t.string "tags"
    t.integer "size_mb"
    t.string "duration"
    t.integer "number_of_tracks"
    t.bigint "sound_designer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "price_cents", default: 0, null: false
    t.string "sku"
    t.float "version"
    t.string "link"
    t.string "list"
    t.string "product_link"
    t.integer "display_order"
    t.string "announcement"
    t.index ["sound_designer_id"], name: "index_sfx_packs_on_sound_designer_id"
  end

  create_table "single_tracks", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "category"
    t.string "tags", default: [], array: true
    t.integer "size"
    t.time "duration"
    t.integer "points"
    t.string "sku"
    t.string "link"
    t.integer "display_order"
    t.integer "sfx_pack_id"
    t.bigint "sound_designer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "price_cents", default: 0, null: false
    t.integer "bitrate"
    t.integer "sample_rate"
    t.integer "batch"
    t.string "preview_link"
    t.integer "announcement"
    t.index ["sound_designer_id"], name: "index_single_tracks_on_sound_designer_id"
  end

  create_table "sound_designers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "address"
    t.string "location"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "bio"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_sound_designers_on_user_id"
  end

  create_table "template_collections", force: :cascade do |t|
    t.string "title"
    t.integer "total_points"
    t.integer "tracks", default: [], array: true
    t.string "categories", default: [], array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "price_cents", default: 0, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "location"
    t.string "username"
    t.boolean "designer", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "carts", "users"
  add_foreign_key "collections", "template_collections"
  add_foreign_key "collections", "users"
  add_foreign_key "orders", "sfx_packs"
  add_foreign_key "orders", "users"
  add_foreign_key "sfx_packs", "sound_designers"
  add_foreign_key "single_tracks", "sound_designers"
  add_foreign_key "sound_designers", "users"
end
