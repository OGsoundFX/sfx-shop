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

ActiveRecord::Schema[7.1].define(version: 2025_10_02_075148) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
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
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name"
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "annoucements", force: :cascade do |t|
    t.string "title"
    t.string "content"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "carts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "items", default: [], array: true
    t.integer "sinlge_tracks", default: [], array: true
    t.integer "collections", default: [], array: true
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "collection_categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price_cents", default: 0, null: false
    t.integer "points"
  end

  create_table "collections", force: :cascade do |t|
    t.integer "total_points"
    t.integer "tracks", default: [], array: true
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price_cents", default: 0, null: false
    t.string "title"
    t.boolean "purchased", default: false
    t.bigint "template_collection_id"
    t.index ["template_collection_id"], name: "index_collections_on_template_collection_id"
    t.index ["user_id"], name: "index_collections_on_user_id"
  end

  create_table "currency_rates", force: :cascade do |t|
    t.string "base", null: false
    t.string "target", null: false
    t.decimal "rate", precision: 12, scale: 6
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "designer_submissions", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "location"
    t.string "email"
    t.string "random_password"
    t.boolean "individual_tracks"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "access_token"
    t.index ["access_token"], name: "index_designer_submissions_on_access_token", unique: true
  end

  create_table "download_links", force: :cascade do |t|
    t.string "url"
    t.string "token"
    t.datetime "validity_duration", precision: nil
    t.bigint "collection_id"
    t.boolean "collection_download"
    t.bigint "order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "job_id"
    t.index ["collection_id"], name: "index_download_links_on_collection_id"
    t.index ["order_id"], name: "index_download_links_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "product_link"
    t.string "sku"
    t.string "status"
    t.integer "amount_cents", default: 0, null: false
    t.string "checkout_session_id"
    t.bigint "user_id", null: false
    t.bigint "sfx_pack_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "payment_infos", force: :cascade do |t|
    t.integer "preferred_method", default: 0
    t.string "paypal_account"
    t.integer "status", default: 0
    t.bigint "sound_designer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sound_designer_id"], name: "index_payment_infos_on_sound_designer_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "rating"
    t.text "content"
    t.string "author"
    t.integer "status"
    t.bigint "user_id", null: false
    t.bigint "sfx_pack_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.index ["sfx_pack_id"], name: "index_reviews_on_sfx_pack_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "sales", force: :cascade do |t|
    t.string "title"
    t.integer "percentage"
    t.date "start_date"
    t.date "end_date"
    t.integer "packs", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price_cents", default: 0, null: false
    t.string "sku"
    t.float "version"
    t.string "link"
    t.string "list"
    t.string "product_link"
    t.integer "display_order"
    t.string "announcement"
    t.integer "status"
    t.integer "currency", default: 0
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price_cents", default: 0, null: false
    t.integer "bitrate"
    t.integer "sample_rate"
    t.integer "batch"
    t.string "preview_link"
    t.integer "announcement"
    t.boolean "loop", default: false
    t.integer "original_points", default: 0
    t.boolean "fantasy", default: false
    t.index ["sound_designer_id"], name: "index_single_tracks_on_sound_designer_id"
  end

  create_table "solid_queue_blocked_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.string "concurrency_key", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.index ["concurrency_key", "priority", "job_id"], name: "index_solid_queue_blocked_executions_for_release"
    t.index ["expires_at", "concurrency_key"], name: "index_solid_queue_blocked_executions_for_maintenance"
    t.index ["job_id"], name: "index_solid_queue_blocked_executions_on_job_id", unique: true
  end

  create_table "solid_queue_claimed_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "process_id"
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_claimed_executions_on_job_id", unique: true
    t.index ["process_id", "job_id"], name: "index_solid_queue_claimed_executions_on_process_id_and_job_id"
  end

  create_table "solid_queue_failed_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.text "error"
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_failed_executions_on_job_id", unique: true
  end

  create_table "solid_queue_jobs", force: :cascade do |t|
    t.string "queue_name", null: false
    t.string "class_name", null: false
    t.text "arguments"
    t.integer "priority", default: 0, null: false
    t.string "active_job_id"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.string "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active_job_id"], name: "index_solid_queue_jobs_on_active_job_id"
    t.index ["class_name"], name: "index_solid_queue_jobs_on_class_name"
    t.index ["finished_at"], name: "index_solid_queue_jobs_on_finished_at"
    t.index ["queue_name", "finished_at"], name: "index_solid_queue_jobs_for_filtering"
    t.index ["scheduled_at", "finished_at"], name: "index_solid_queue_jobs_for_alerting"
  end

  create_table "solid_queue_pauses", force: :cascade do |t|
    t.string "queue_name", null: false
    t.datetime "created_at", null: false
    t.index ["queue_name"], name: "index_solid_queue_pauses_on_queue_name", unique: true
  end

  create_table "solid_queue_processes", force: :cascade do |t|
    t.string "kind", null: false
    t.datetime "last_heartbeat_at", null: false
    t.bigint "supervisor_id"
    t.integer "pid", null: false
    t.string "hostname"
    t.text "metadata"
    t.datetime "created_at", null: false
    t.index ["last_heartbeat_at"], name: "index_solid_queue_processes_on_last_heartbeat_at"
    t.index ["supervisor_id"], name: "index_solid_queue_processes_on_supervisor_id"
  end

  create_table "solid_queue_ready_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_ready_executions_on_job_id", unique: true
    t.index ["priority", "job_id"], name: "index_solid_queue_poll_all"
    t.index ["queue_name", "priority", "job_id"], name: "index_solid_queue_poll_by_queue"
  end

  create_table "solid_queue_recurring_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "task_key", null: false
    t.datetime "run_at", null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_recurring_executions_on_job_id", unique: true
    t.index ["task_key", "run_at"], name: "index_solid_queue_recurring_executions_on_task_key_and_run_at", unique: true
  end

  create_table "solid_queue_scheduled_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "scheduled_at", null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_scheduled_executions_on_job_id", unique: true
    t.index ["scheduled_at", "priority", "job_id"], name: "index_solid_queue_dispatch_all"
  end

  create_table "solid_queue_semaphores", force: :cascade do |t|
    t.string "key", null: false
    t.integer "value", default: 1, null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expires_at"], name: "index_solid_queue_semaphores_on_expires_at"
    t.index ["key", "value"], name: "index_solid_queue_semaphores_on_key_and_value"
    t.index ["key"], name: "index_solid_queue_semaphores_on_key", unique: true
  end

  create_table "sound_designers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "address"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "bio"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_sound_designers_on_user_id"
  end

  create_table "submission_links", force: :cascade do |t|
    t.string "url"
    t.string "title"
    t.text "description"
    t.bigint "designer_submission_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["designer_submission_id"], name: "index_submission_links_on_designer_submission_id"
  end

  create_table "template_collections", force: :cascade do |t|
    t.string "title"
    t.integer "total_points"
    t.integer "tracks", default: [], array: true
    t.string "categories", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price_cents", default: 0, null: false
    t.boolean "active", default: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "location"
    t.string "username"
    t.boolean "designer", default: false
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "carts", "users"
  add_foreign_key "collections", "template_collections"
  add_foreign_key "collections", "users"
  add_foreign_key "download_links", "collections"
  add_foreign_key "download_links", "orders"
  add_foreign_key "orders", "sfx_packs"
  add_foreign_key "orders", "users"
  add_foreign_key "payment_infos", "sound_designers"
  add_foreign_key "reviews", "sfx_packs"
  add_foreign_key "reviews", "users"
  add_foreign_key "sfx_packs", "sound_designers"
  add_foreign_key "single_tracks", "sound_designers"
  add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_recurring_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "sound_designers", "users"
  add_foreign_key "submission_links", "designer_submissions"
end
