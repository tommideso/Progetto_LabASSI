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

ActiveRecord::Schema[7.2].define(version: 2024_08_15_135918) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.boolean "disattivato"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
