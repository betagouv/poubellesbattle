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

ActiveRecord::Schema.define(version: 2019_12_05_130919) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "composteurs", force: :cascade do |t|
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address"
    t.string "name"
    t.string "category"
    t.boolean "public"
    t.integer "bacs_number"
    t.string "photo"
    t.string "referent_email"
    t.string "referent_full_name"
    t.date "installation_date"
    t.string "status"
    t.string "volume"
    t.string "publicorprivate"
  end

  create_table "donverts", force: :cascade do |t|
    t.string "title"
    t.string "type_matiere_orga"
    t.string "description"
    t.float "volume_litres"
    t.string "donneur_name"
    t.string "donneur_address"
    t.string "donneur_tel"
    t.string "donneur_email"
    t.date "date_fin_dispo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
