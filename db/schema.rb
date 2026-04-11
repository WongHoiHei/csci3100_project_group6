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

ActiveRecord::Schema[8.1].define(version: 2026_04_10_120000) do
  create_table "bookings", force: :cascade do |t|
    t.integer "bookable_id", null: false
    t.string "bookable_type", null: false
    t.datetime "created_at", null: false
    t.datetime "end_time"
    t.datetime "start_time"
    t.string "status"
    t.integer "time_slot_id"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["bookable_type", "bookable_id"], name: "index_bookings_on_bookable"
    t.index ["time_slot_id"], name: "index_bookings_on_time_slot_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "equipment", force: :cascade do |t|
    t.integer "available_count"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.integer "number_of_past_booking", default: 0, null: false
    t.integer "tenant_id", null: false
    t.integer "total_count"
    t.datetime "updated_at", null: false
    t.integer "usage_count", default: 0, null: false
    t.index ["tenant_id"], name: "index_equipment_on_tenant_id"
  end

  create_table "locations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "tenants", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "time_slots", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.time "end_time"
    t.time "start_time"
    t.datetime "updated_at", null: false
    t.integer "venue_id", null: false
    t.index ["venue_id"], name: "index_time_slots_on_venue_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.string "role"
    t.datetime "updated_at", null: false
  end

  create_table "venues", force: :cascade do |t|
    t.integer "booking_count", default: 0, null: false
    t.integer "capacity"
    t.datetime "created_at", null: false
    t.integer "location_id"
    t.string "name"
    t.integer "number_of_past_booking", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_venues_on_location_id"
  end

  add_foreign_key "bookings", "time_slots"
  add_foreign_key "bookings", "users"
  add_foreign_key "equipment", "tenants"
  add_foreign_key "time_slots", "venues"
  add_foreign_key "venues", "locations"
end
