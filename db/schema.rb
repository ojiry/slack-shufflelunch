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

ActiveRecord::Schema.define(version: 2018_03_02_160745) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "channels", force: :cascade do |t|
    t.string "slack_id", null: false
    t.string "name", null: false
    t.bigint "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slack_id"], name: "index_channels_on_slack_id", unique: true
    t.index ["team_id"], name: "index_channels_on_team_id"
  end

  create_table "group_members", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id", "user_id"], name: "index_group_members_on_group_id_and_user_id", unique: true
    t.index ["user_id"], name: "index_group_members_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.bigint "lunch_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lunch_id", "name"], name: "index_groups_on_lunch_id_and_name", unique: true
  end

  create_table "lunches", force: :cascade do |t|
    t.bigint "channel_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "shuffled_at"
    t.string "response_url", null: false
    t.string "event_id"
    t.index ["channel_id"], name: "index_lunches_on_channel_id"
    t.index ["user_id"], name: "index_lunches_on_user_id"
  end

  create_table "participations", force: :cascade do |t|
    t.bigint "lunch_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lunch_id", "user_id"], name: "index_participations_on_lunch_id_and_user_id", unique: true
    t.index ["user_id"], name: "index_participations_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "slack_id", null: false
    t.string "domain", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slack_id"], name: "index_teams_on_slack_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "slack_id", null: false
    t.string "username", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "team_id", null: false
    t.index ["slack_id"], name: "index_users_on_slack_id", unique: true
    t.index ["team_id"], name: "index_users_on_team_id"
  end

  add_foreign_key "channels", "teams"
  add_foreign_key "group_members", "groups"
  add_foreign_key "group_members", "users"
  add_foreign_key "groups", "lunches"
  add_foreign_key "lunches", "channels"
  add_foreign_key "lunches", "users"
  add_foreign_key "participations", "lunches"
  add_foreign_key "participations", "users"
  add_foreign_key "users", "teams"
end
