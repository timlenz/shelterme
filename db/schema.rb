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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130617045526) do

  create_table "addresses", :force => true do |t|
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.integer  "shelter_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.float    "latitude"
    t.float    "longitude"
  end

  add_index "addresses", ["shelter_id"], :name => "index_addresses_on_shelter_id"

  create_table "affections", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "age_groups", :force => true do |t|
    t.string   "group"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "age_periods", :force => true do |t|
    t.string   "length"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "ages", :force => true do |t|
    t.integer  "number"
    t.integer  "age_period_id"
    t.integer  "age_group_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "attitude_values", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "bonds", :force => true do |t|
    t.integer  "user_id"
    t.integer  "pet_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "bonds", ["pet_id"], :name => "index_bonds_on_pet_id"
  add_index "bonds", ["user_id", "pet_id"], :name => "index_bonds_on_user_id_and_pet_id", :unique => true
  add_index "bonds", ["user_id"], :name => "index_bonds_on_user_id"

  create_table "breeds", :force => true do |t|
    t.string   "name"
    t.integer  "species_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "clean_values", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "emotion_values", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "energy_levels", :force => true do |t|
    t.string   "level"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "energy_values", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "favorites", :force => true do |t|
    t.integer  "user_id"
    t.integer  "shelter_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "favorites", ["shelter_id"], :name => "index_favorites_on_shelter_id"
  add_index "favorites", ["user_id", "shelter_id"], :name => "index_favorites_on_user_id_and_shelter_id", :unique => true
  add_index "favorites", ["user_id"], :name => "index_favorites_on_user_id"

  create_table "fur_colors", :force => true do |t|
    t.string   "color"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "fur_lengths", :force => true do |t|
    t.string   "length"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "genders", :force => true do |t|
    t.string   "sex"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "journals", :force => true do |t|
    t.integer  "shelter_id"
    t.integer  "pet_id"
    t.integer  "pet_state_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "old_pet_state_id"
  end

  add_index "journals", ["old_pet_state_id"], :name => "index_journals_on_old_pet_state_id"
  add_index "journals", ["pet_id"], :name => "index_journals_on_pet_id"
  add_index "journals", ["pet_state_id"], :name => "index_journals_on_pet_state_id"
  add_index "journals", ["shelter_id"], :name => "index_journals_on_shelter_id"

  create_table "microposts", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "pet_id"
    t.boolean  "flagged",    :default => false
  end

  add_index "microposts", ["pet_id", "created_at"], :name => "index_microposts_on_pet_id_and_created_at"
  add_index "microposts", ["user_id", "created_at"], :name => "index_microposts_on_user_id_and_created_at"

  create_table "mixes", :force => true do |t|
    t.integer  "primary_breed_id"
    t.integer  "secondary_breed_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "mixes", ["primary_breed_id", "secondary_breed_id"], :name => "index_mixes_on_primary_breed_id_and_secondary_breed_id", :unique => true
  add_index "mixes", ["primary_breed_id"], :name => "index_mixes_on_primary_breed_id"
  add_index "mixes", ["secondary_breed_id"], :name => "index_mixes_on_secondary_breed_id"

  create_table "natures", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "open_values", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pet_photos", :force => true do |t|
    t.integer  "pet_id"
    t.string   "image"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "primary",    :default => false
    t.integer  "user_id"
  end

  add_index "pet_photos", ["pet_id"], :name => "index_pet_photos_on_pet_id"
  add_index "pet_photos", ["user_id", "created_at"], :name => "index_pet_photos_on_user_id_and_created_at"

  create_table "pet_states", :force => true do |t|
    t.string   "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pet_videos", :force => true do |t|
    t.integer  "pet_id"
    t.string   "panda_video_id"
    t.boolean  "primary",        :default => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "user_id"
  end

  add_index "pet_videos", ["user_id", "created_at"], :name => "index_pet_videos_on_user_id_and_created_at"

  create_table "pets", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "user_id"
    t.string   "animal_code"
    t.integer  "size_id"
    t.integer  "gender_id"
    t.integer  "species_id"
    t.integer  "pet_state_id"
    t.integer  "weight"
    t.integer  "shelter_id"
    t.float    "age"
    t.integer  "age_period_id"
    t.integer  "affection_id"
    t.integer  "energy_level_id"
    t.integer  "nature_id"
    t.integer  "primary_color_id"
    t.integer  "secondary_color_id"
    t.integer  "fur_length_id"
    t.integer  "primary_breed_id"
    t.integer  "secondary_breed_id"
    t.string   "slug"
    t.integer  "pet_photos_count",   :default => 0, :null => false
    t.integer  "watchers_count",     :default => 0, :null => false
  end

  add_index "pets", ["affection_id"], :name => "index_pets_on_affection_id"
  add_index "pets", ["age_period_id"], :name => "index_pets_on_age_period_id"
  add_index "pets", ["animal_code", "shelter_id"], :name => "index_pets_on_animal_code_and_shelter_id", :unique => true
  add_index "pets", ["energy_level_id"], :name => "index_pets_on_energy_level_id"
  add_index "pets", ["fur_length_id"], :name => "index_pets_on_fur_length_id"
  add_index "pets", ["gender_id"], :name => "index_pets_on_gender_id"
  add_index "pets", ["nature_id"], :name => "index_pets_on_nature_id"
  add_index "pets", ["pet_state_id"], :name => "index_pets_on_pet_state_id"
  add_index "pets", ["primary_breed_id"], :name => "index_pets_on_primary_breed_id"
  add_index "pets", ["primary_color_id"], :name => "index_pets_on_primary_color_id"
  add_index "pets", ["secondary_breed_id"], :name => "index_pets_on_secondary_breed_id"
  add_index "pets", ["secondary_color_id"], :name => "index_pets_on_secondary_color_id"
  add_index "pets", ["shelter_id", "created_at"], :name => "index_pets_on_shelter_id_and_created_at"
  add_index "pets", ["size_id"], :name => "index_pets_on_size_id"
  add_index "pets", ["slug"], :name => "index_pets_on_slug"
  add_index "pets", ["species_id"], :name => "index_pets_on_species_id"
  add_index "pets", ["user_id", "created_at"], :name => "index_pets_on_user_id_and_created_at"

  create_table "plan_values", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "precedences", :force => true do |t|
    t.string   "rank"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], :name => "index_relationships_on_follower_id_and_followed_id", :unique => true
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "searches", :force => true do |t|
    t.integer  "species_id"
    t.string   "age_group"
    t.integer  "gender_id"
    t.integer  "breed_id"
    t.integer  "size_id"
    t.integer  "energy_level_id"
    t.integer  "affection_id"
    t.integer  "nature_id"
    t.string   "location"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "user_id"
    t.boolean  "save_search",     :default => false
  end

  add_index "searches", ["user_id"], :name => "index_searches_on_user_id"

  create_table "shelter_admins", :force => true do |t|
    t.integer  "user_id"
    t.integer  "shelter_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "shelter_admins", ["shelter_id"], :name => "index_shelter_admins_on_shelter_id"
  add_index "shelter_admins", ["user_id", "shelter_id"], :name => "index_shelter_admins_on_user_id_and_shelter_id", :unique => true
  add_index "shelter_admins", ["user_id"], :name => "index_shelter_admins_on_user_id"

  create_table "shelter_hours", :force => true do |t|
    t.integer  "shelter_id"
    t.integer  "day",        :limit => 2
    t.time     "open_time"
    t.time     "close_time"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "shelters", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "precedence_id", :default => 1
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "sun_hours"
    t.string   "mon_hours"
    t.string   "tue_hours"
    t.string   "wed_hours"
    t.string   "thu_hours"
    t.string   "fri_hours"
    t.string   "sat_hours"
    t.string   "slug"
  end

  add_index "shelters", ["precedence_id", "created_at"], :name => "index_shelters_on_precedence_id_and_created_at"
  add_index "shelters", ["slug"], :name => "index_shelters_on_slug"

  create_table "sizes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "social_values", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "species", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",                  :default => false
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "location"
    t.text     "bio"
    t.string   "phone"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "manager",                :default => false
    t.integer  "shelter_id"
    t.integer  "open_value_id"
    t.integer  "plan_value_id"
    t.integer  "social_value_id"
    t.integer  "attitude_value_id"
    t.integer  "emotion_value_id"
    t.integer  "clean_value_id"
    t.integer  "energy_value_id"
    t.integer  "species_id"
    t.string   "slug"
    t.string   "avatar"
  end

  add_index "users", ["attitude_value_id"], :name => "index_users_on_attitude_value_id"
  add_index "users", ["clean_value_id"], :name => "index_users_on_clean_value_id"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["emotion_value_id"], :name => "index_users_on_emotion_value_id"
  add_index "users", ["energy_value_id"], :name => "index_users_on_energy_value_id"
  add_index "users", ["open_value_id"], :name => "index_users_on_open_value_id"
  add_index "users", ["plan_value_id"], :name => "index_users_on_plan_value_id"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"
  add_index "users", ["slug"], :name => "index_users_on_slug"
  add_index "users", ["social_value_id"], :name => "index_users_on_social_value_id"
  add_index "users", ["species_id"], :name => "index_users_on_species_id"

end
