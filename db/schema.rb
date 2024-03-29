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

ActiveRecord::Schema.define(:version => 20110119212152) do

  create_table "addresses", :force => true do |t|
    t.string   "address"
    t.float    "lat",         :default => 0.0
    t.float    "lng",         :default => 0.0
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

  create_table "attractions", :force => true do |t|
    t.string   "identity_url"
    t.float    "lat"
    t.float    "lng"
    t.integer  "popularity",   :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "city_id"
  end

  create_table "book_tips", :force => true do |t|
    t.integer  "book_id"
    t.integer  "tip_id"
    t.integer  "image_offset_x", :default => 0
    t.integer  "image_offset_y", :default => 0
    t.string   "name"
    t.text     "description"
    t.string   "url"
    t.string   "phone"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rank"
  end

  create_table "books", :force => true do |t|
    t.integer  "calendar_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "calendars", :force => true do |t|
    t.string   "name"
    t.integer  "view_count",           :default => 0
    t.integer  "click_count",          :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "location_id"
    t.integer  "votes_sum",            :default => 0
    t.integer  "votes_num",            :default => 0
    t.string   "name_location"
    t.string   "name_target"
    t.boolean  "public",               :default => false
    t.integer  "guide_type_id"
    t.integer  "completed_percentage", :default => 0
    t.text     "description"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "image_remote_url"
    t.float    "rating",               :default => 0.0
  end

  create_table "conditions", :force => true do |t|
    t.string   "name"
    t.string   "weather"
    t.string   "full_name"
    t.integer  "guide_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "group"
  end

  create_table "guide_layouts", :force => true do |t|
    t.string   "name"
    t.string   "path"
    t.boolean  "public",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "guide_types", :force => true do |t|
    t.string "name"
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :null => false
    t.string  "server_url"
    t.string  "salt",       :null => false
  end

  create_table "photos", :force => true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.string   "image_file_size"
    t.datetime "image_updated_at"
    t.string   "image_remote_url"
    t.integer  "image_width"
    t.integer  "image_height"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "imageable_id"
    t.string   "imageable_type"
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
    t.text     "description"
    t.string   "url",                             :default => ""
    t.integer  "view_count",                      :default => 0
    t.integer  "click_count",                     :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "advertisement",                   :default => false
    t.integer  "author_id"
    t.string   "image_remote_url"
    t.string   "phone"
    t.integer  "weekday_id"
    t.string   "good_on",            :limit => 7, :default => "xxxxxxx"
    t.integer  "day",                             :default => 0
    t.integer  "rank",                            :default => 0
    t.integer  "image_width"
    t.integer  "image_height"
    t.string   "address",                         :default => ""
    t.integer  "attraction_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "identity_url"
    t.boolean  "registration_complete"
    t.boolean  "admin",                 :default => false
    t.text     "bio"
    t.string   "public_email"
    t.string   "website"
    t.string   "facebook"
    t.string   "twitter"
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
