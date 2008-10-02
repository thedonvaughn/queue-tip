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

ActiveRecord::Schema.define(:version => 20080923151138) do

  create_table "aactions", :force => true do |t|
    t.integer  "agent_id"
    t.string   "channel"
    t.float    "timestamp"
    t.integer  "queu_id"
    t.string   "queue_name"
    t.float    "uniqueid"
    t.string   "action"
    t.string   "field1"
    t.string   "field2"
    t.string   "field3"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "agents", :force => true do |t|
    t.string   "channel"
    t.string   "first"
    t.string   "last"
    t.string   "exten"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cactions", :force => true do |t|
    t.integer  "call_id"
    t.float    "timestamp"
    t.float    "uniqueid"
    t.integer  "agent_id"
    t.integer  "queu_id"
    t.string   "queue_name"
    t.string   "channel"
    t.string   "action"
    t.string   "field1"
    t.string   "field2"
    t.string   "field3"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "calls", :force => true do |t|
    t.string   "cid"
    t.integer  "queu_id"
    t.string   "queue_name"
    t.float    "timestamp"
    t.float    "uniqueid"
    t.integer  "agent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "queus", :force => true do |t|
    t.string   "queue_name"
    t.string   "exten"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
