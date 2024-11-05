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

ActiveRecord::Schema[7.2].define(version: 2024_11_04_161520) do
  create_table "domains", force: :cascade do |t|
    t.integer "team_id", null: false
    t.string "address"
    t.string "status"
    t.string "external_hostname_id"
    t.string "txt_verification_name"
    t.string "txt_verification_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "address" ], name: "index_domains_on_address", unique: true
    t.index [ "external_hostname_id" ], name: "index_domains_on_external_hostname_id"
    t.index [ "team_id" ], name: "index_domains_on_team_id"
  end

  # add_foreign_key "domains", "teams"
end
