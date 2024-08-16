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

ActiveRecord::Schema[7.2].define(version: 2024_08_16_210516) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chefs", force: :cascade do |t|
    t.string "indirizzo"
    t.string "telefono"
    t.integer "raggio"
    t.text "descrizione"
    t.boolean "bloccato", default: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_chefs_on_user_id", unique: true
  end

  create_table "clients", force: :cascade do |t|
    t.jsonb "allergeni"
    t.string "indirizzo"
    t.string "telefono"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_clients_on_user_id", unique: true
  end

  create_table "menus", force: :cascade do |t|
    t.string "titolo"
    t.text "descrizione"
    t.decimal "prezzo_persona"
    t.integer "min_persone"
    t.integer "max_persone"
    t.string "tipo_cucina"
    t.jsonb "allergeni"
    t.jsonb "preferenze_alimentari"
    t.jsonb "adattabile"
    t.jsonb "extra"
    t.decimal "prezzo_extra"
    t.boolean "disattivato", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "nome"
    t.string "cognome"
    t.string "ruolo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "inizializzato"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["ruolo"], name: "index_users_on_ruolo"
  end

  add_foreign_key "chefs", "users"
  add_foreign_key "clients", "users"
end
