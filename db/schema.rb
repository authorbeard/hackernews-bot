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

ActiveRecord::Schema[7.0].define(version: 2023_11_02_162642) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.string "by"
    t.text "text"
    t.timestamptz "posted_at"
    t.integer "score"
    t.string "hn_id"
    t.string "hn_type"
    t.bigint "story_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["story_id"], name: "index_comments_on_story_id"
  end

  create_table "stories", force: :cascade do |t|
    t.string "title"
    t.string "hn_type"
    t.string "by"
    t.timestamptz "posted_at"
    t.text "text"
    t.integer "score"
    t.string "hn_id"
    t.integer "descendant_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "top_stories_idx"
    t.string "url", default: "https://news.ycombinator.com/"
    t.index ["hn_id"], name: "index_stories_on_hn_id", unique: true
  end

  create_table "tasks", force: :cascade do |t|
    t.string "description", limit: 200
    t.boolean "completed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
  end

end
