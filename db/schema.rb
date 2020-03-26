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

ActiveRecord::Schema.define(version: 2020_03_26_095917) do

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

  create_table "composteurs", force: :cascade do |t|
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address"
    t.string "name"
    t.string "category"
    t.boolean "public"
    t.date "installation_date"
    t.string "status"
    t.string "volume"
    t.string "residence_name"
    t.string "commentaire"
    t.integer "participants"
    t.string "composteur_type"
    t.date "date_retournement"
  end

  create_table "demandes", force: :cascade do |t|
    t.string "status"
    t.string "logement_type"
    t.string "inhabitant_type"
    t.string "address"
    t.boolean "location_found"
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.boolean "potential_users"
    t.boolean "completed_form"
    t.date "planification_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug", null: false
    t.string "potential_address"
    t.string "notes_to_collegues"
    t.index ["slug"], name: "index_demandes_on_slug", unique: true
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
    t.string "slug", null: false
    t.boolean "pourvu", default: false
    t.string "donateur_type"
    t.bigint "user_id"
    t.string "codeword"
    t.boolean "archived", default: false
    t.index ["slug"], name: "index_donverts_on_slug", unique: true
    t.index ["user_id"], name: "index_donverts_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "subject"
    t.string "content"
    t.string "sender_email"
    t.string "sender_full_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "donvert_id"
    t.index ["donvert_id"], name: "index_messages_on_donvert_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "notification_type"
    t.string "content"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.string "role"
    t.bigint "composteur_id"
    t.boolean "ok_phone"
    t.boolean "ok_mail"
    t.index ["composteur_id"], name: "index_users_on_composteur_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "donverts", "users"
  add_foreign_key "messages", "donverts"
  add_foreign_key "notifications", "users"
  add_foreign_key "users", "composteurs"
end
