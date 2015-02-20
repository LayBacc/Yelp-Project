# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150220091235) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "areas", force: true do |t|
    t.string   "name"
    t.string   "tabelog_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "areas", ["tabelog_code"], name: "index_areas_on_tabelog_code", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.string   "name_jp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["name"], name: "index_categories_on_name", using: :btree

  create_table "feedbacks", force: true do |t|
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matches", force: true do |t|
    t.integer  "first_id"
    t.integer  "second_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "winner"
  end

  create_table "restaurant_categories", force: true do |t|
    t.integer  "restaurant_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "restaurant_categories", ["category_id"], name: "index_restaurant_categories_on_category_id", using: :btree
  add_index "restaurant_categories", ["restaurant_id"], name: "index_restaurant_categories_on_restaurant_id", using: :btree

  create_table "restaurant_images", force: true do |t|
    t.string   "url"
    t.integer  "restaurant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.integer  "user_id"
  end

  create_table "restaurants", force: true do |t|
    t.string   "name",             null: false
    t.text     "description"
    t.string   "telephone"
    t.string   "hours"
    t.string   "street_address"
    t.text     "direction"
    t.string   "holiday"
    t.string   "lunch_price"
    t.string   "dinner_price"
    t.string   "tabelog_url"
    t.string   "city"
    t.integer  "area"
    t.integer  "subarea"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "seats"
    t.string   "parking"
    t.string   "facilities"
    t.string   "home_page"
    t.string   "opening_date"
    t.string   "tabelog_group_id"
    t.string   "lunch_prices"
    t.string   "dinner_prices"
    t.string   "purposes"
  end

  add_index "restaurants", ["area"], name: "index_restaurants_on_area", using: :btree
  add_index "restaurants", ["city"], name: "index_restaurants_on_city", using: :btree
  add_index "restaurants", ["latitude"], name: "index_restaurants_on_latitude", using: :btree
  add_index "restaurants", ["longitude"], name: "index_restaurants_on_longitude", using: :btree
  add_index "restaurants", ["subarea"], name: "index_restaurants_on_subarea", using: :btree
  add_index "restaurants", ["tabelog_url"], name: "index_restaurants_on_tabelog_url", using: :btree

  create_table "reviews", force: true do |t|
    t.integer  "user_id"
    t.integer  "restaurant_id"
    t.text     "body"
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subareas", force: true do |t|
    t.string   "name"
    t.integer  "area_id"
    t.string   "tabelog_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subareas", ["name"], name: "index_subareas_on_name", using: :btree
  add_index "subareas", ["tabelog_code"], name: "index_subareas_on_tabelog_code", using: :btree

  create_table "user_restaurants", force: true do |t|
    t.integer  "user_id"
    t.integer  "restaurant_id"
    t.integer  "context"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "profile_image_url"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
