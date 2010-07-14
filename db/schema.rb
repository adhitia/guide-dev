# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100714175945) do

  create_table "addresses", :force => true do |t|
    t.string   "address"
    t.float    "lat"
    t.float    "lng"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "location_id"
    t.integer  "tip_id"
  end

  create_table "advertisements", :force => true do |t|
    t.integer  "condition_id"
    t.integer  "weekday_id"
    t.integer  "calendar_id"
    t.integer  "user_id"
    t.integer  "views_total"
    t.integer  "views_paid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active"
  end

  create_table "calendars", :force => true do |t|
    t.string   "name"
    t.string   "author"
    t.integer  "view_count",    :default => 0
    t.integer  "click_count",   :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "location_id"
    t.integer  "votes_sum",     :default => 0
    t.integer  "votes_num",     :default => 0
    t.string   "name_location"
    t.string   "name_target"
  end

  create_table "conditions", :force => true do |t|
    t.string   "name"
    t.string   "weather"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "show_places", :force => true do |t|
    t.integer  "condition_id"
    t.integer  "weekday_id"
    t.integer  "calendar_id"
    t.integer  "tip_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tips", :force => true do |t|
    t.integer  "condition_id"
    t.integer  "calendar_id"
    t.string   "name"
    t.string   "description",        :default => ""
    t.string   "url",                :default => ""
    t.integer  "view_count",         :default => 0
    t.integer  "click_count",        :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "advertisement",      :default => false
    t.integer  "author_id"
    t.string   "image_remote_url"
    t.string   "phone"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "name"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "weather_forecasts", :force => true do |t|
    t.datetime "last_checked"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "data",         :limit => 1000
  end

  create_table "weekdays", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
