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

ActiveRecord::Schema.define(version: 20170314034412) do

  create_table "players", force: :cascade do |t|
    t.string   "name",          null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "tournament_id"
    t.index ["tournament_id"], name: "index_players_on_tournament_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "tournament_id"
    t.integer  "number",        default: 1, null: false
    t.index ["tournament_id"], name: "index_rounds_on_tournament_id"
  end

  create_table "scores", force: :cascade do |t|
    t.integer  "vp_numerator"
    t.integer  "vp_denominator"
    t.boolean  "has_extra_turn", default: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "player_id"
    t.integer  "table_id"
    t.index ["player_id"], name: "index_scores_on_player_id"
    t.index ["table_id"], name: "index_scores_on_table_id"
  end

  create_table "tables", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "round_id"
    t.index ["round_id"], name: "index_tables_on_round_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
