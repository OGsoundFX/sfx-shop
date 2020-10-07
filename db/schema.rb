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

ActiveRecord::Schema.define(version: 2020_10_07_151235) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "sfx_packs", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "category"
    t.string "tags"
    t.integer "size_mb"
    t.string "duration"
    t.integer "number_of_tracks"
    t.decimal "price"
    t.bigint "sound_designer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["sound_designer_id"], name: "index_sfx_packs_on_sound_designer_id"
  end

  create_table "sound_designers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password"
    t.string "address"
    t.string "location"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "sfx_packs", "sound_designers"
end
