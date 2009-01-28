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

ActiveRecord::Schema.define(:version => 4) do

  create_table "actions", :force => true do |t|
    t.integer  "timestamp",  :limit => 10
    t.string   "uniqueid",   :limit => 32
    t.string   "queue_name", :limit => 32
    t.string   "channel",    :limit => 45
    t.string   "action",     :limit => 32
    t.string   "data1"
    t.string   "data2"
    t.string   "data3"
    t.integer  "agent_id",   :limit => 12
    t.integer  "queu_id",    :limit => 12
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "agents", :force => true do |t|
    t.string   "channel",    :limit => 45
    t.string   "first",      :limit => 16
    t.string   "last",       :limit => 16
    t.string   "exten",      :limit => 12
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "name",        :limit => 45
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "queus", :force => true do |t|
    t.string   "queue_name",  :limit => 25
    t.string   "exten",       :limit => 12
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
