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

ActiveRecord::Schema.define(:version => 20111106230256) do

  create_table "cardtables", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "player_id"
    t.integer  "dealer_id"
    t.integer  "game_id"
    t.text     "player"
    t.text     "dealer"
    t.text     "deck"
    t.decimal  "bet"
  end

  create_table "games", :force => true do |t|
    t.integer  "user_id"
    t.integer  "session_num"
    t.integer  "game_num"
    t.boolean  "win"
    t.decimal  "amount"
    t.integer  "num_cards"
    t.integer  "card_count"
    t.integer  "dealer_count"
    t.datetime "date_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.integer  "dealer_game_num"
    t.integer  "dealer_num_cards"
    t.integer  "dealer_session_num"
  end

  create_table "user_sessions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.integer  "games_played"
    t.integer  "games_lost"
    t.integer  "games_won"
    t.decimal  "balance"
    t.decimal  "cashflow"
    t.integer  "num_sessions"
    t.integer  "games_per_session_avg"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
