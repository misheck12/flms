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

ActiveRecord::Schema[7.0].define(version: 2024_11_26_235920) do
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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "league_standings", force: :cascade do |t|
    t.integer "league_id", null: false
    t.integer "team_id", null: false
    t.integer "position"
    t.integer "points"
    t.integer "goal_difference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["league_id"], name: "index_league_standings_on_league_id"
    t.index ["team_id"], name: "index_league_standings_on_team_id"
  end

  create_table "leagues", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.date "start_date"
    t.date "end_date"
    t.text "rules"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "match_reports", force: :cascade do |t|
    t.integer "match_id", null: false
    t.integer "referee_id", null: false
    t.text "report_details"
    t.json "goal_scorers"
    t.json "cards"
    t.text "notable_incidents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_match_reports_on_match_id"
    t.index ["referee_id"], name: "index_match_reports_on_referee_id"
  end

  create_table "matches", force: :cascade do |t|
    t.integer "league_id", null: false
    t.integer "home_team_id", null: false
    t.integer "away_team_id", null: false
    t.date "date"
    t.time "time"
    t.string "venue"
    t.integer "home_team_score"
    t.integer "away_team_score"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["away_team_id"], name: "index_matches_on_away_team_id"
    t.index ["home_team_id"], name: "index_matches_on_home_team_id"
    t.index ["league_id"], name: "index_matches_on_league_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "user_id", null: false
    t.text "message"
    t.datetime "sent_at"
    t.boolean "read"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "players", force: :cascade do |t|
    t.integer "team_id", null: false
    t.string "name"
    t.string "position"
    t.string "profile_picture"
    t.integer "goals"
    t.integer "assists"
    t.integer "clean_sheets"
    t.integer "yellow_cards"
    t.integer "red_cards"
    t.boolean "injury_status"
    t.text "injury_details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_players_on_team_id"
  end

  create_table "referees", force: :cascade do |t|
    t.integer "user_id", null: false
    t.json "availability"
    t.json "claimed_matches"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_referees_on_user_id"
  end

  create_table "team_histories", force: :cascade do |t|
    t.integer "team_id", null: false
    t.integer "season_year"
    t.integer "wins"
    t.integer "draws"
    t.integer "losses"
    t.integer "goals_scored"
    t.integer "goals_conceded"
    t.integer "goal_difference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_team_histories_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.integer "league_id", null: false
    t.string "name"
    t.string "logo"
    t.text "bio"
    t.string "contact_email"
    t.string "contact_phone"
    t.integer "points"
    t.integer "wins"
    t.integer "draws"
    t.integer "losses"
    t.integer "goals_scored"
    t.integer "goals_conceded"
    t.integer "goal_difference"
    t.integer "matches_played"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.string "city"
    t.string "stadium"
    t.integer "foundation_year"
    t.string "president"
    t.string "manager"
    t.index ["league_id"], name: "index_teams_on_league_id"
    t.index ["user_id"], name: "index_teams_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "league_standings", "leagues"
  add_foreign_key "league_standings", "teams"
  add_foreign_key "match_reports", "matches"
  add_foreign_key "match_reports", "referees"
  add_foreign_key "matches", "away_teams"
  add_foreign_key "matches", "home_teams"
  add_foreign_key "matches", "leagues"
  add_foreign_key "notifications", "users"
  add_foreign_key "players", "teams"
  add_foreign_key "referees", "users"
  add_foreign_key "team_histories", "teams"
  add_foreign_key "teams", "leagues"
  add_foreign_key "teams", "users"
end
