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

ActiveRecord::Schema.define(version: 2019_01_12_092138) do

  create_table "players", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tournament_id"
    t.integer "droped_round"
    t.index ["tournament_id"], name: "index_players_on_tournament_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tournament_id"
    t.integer "number", default: 1, null: false
    t.index ["tournament_id"], name: "index_rounds_on_tournament_id"
  end

  create_table "scores", force: :cascade do |t|
    t.integer "vp_numerator"
    t.integer "vp_denominator"
    t.boolean "has_extra_turn", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "player_id"
    t.integer "tp_numerator"
    t.integer "tp_denominator"
    t.integer "rank"
    t.integer "table_number", default: 0, null: false
    t.integer "tournament_id"
    t.integer "round_number", default: 0, null: false
    t.index ["player_id"], name: "index_scores_on_player_id"
    t.index ["tournament_id"], name: "index_scores_on_tournament_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "finished_count", default: 0, null: false
    t.boolean "total_vp_used", default: true, null: false
    t.boolean "rank_history_used", default: true, null: false
  end

end
