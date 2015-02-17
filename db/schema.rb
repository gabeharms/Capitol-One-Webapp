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

ActiveRecord::Schema.define(version: 20150212153208) do

  create_table "comments", force: :cascade do |t|
    t.integer  "ticket_id"
    t.integer  "employee_id"
    t.boolean  "initiator"
    t.text     "message"
    t.string   "picture"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "comments", ["created_at"], name: "index_comments_on_created_at"
  add_index "comments", ["employee_id"], name: "index_comments_on_employee_id"
  add_index "comments", ["ticket_id"], name: "index_comments_on_ticket_id"

  create_table "customers", force: :cascade do |t|
    t.string   "first_name",      limit: 25
    t.string   "last_name",       limit: 50
    t.string   "email",                      default: "", null: false
    t.string   "password_digest"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "customers", ["email"], name: "index_customers_on_email"
  add_index "customers", ["last_name"], name: "index_customers_on_last_name"

  create_table "employees", force: :cascade do |t|
    t.string   "first_name",      limit: 25
    t.string   "last_name",       limit: 50
    t.string   "email",                      default: "", null: false
    t.string   "password_digest"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "employees", ["email"], name: "index_employees_on_email"
  add_index "employees", ["last_name"], name: "index_employees_on_last_name"

  create_table "ticket_catagories", force: :cascade do |t|
    t.string   "name",       limit: 25
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "ticket_statuses", force: :cascade do |t|
    t.string   "status",     limit: 25
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "tickets", force: :cascade do |t|
    t.integer  "customer_id"
    t.integer  "employee_id"
    t.integer  "ticket_category_id"
    t.integer  "ticket_status_id"
    t.boolean  "visible",                       default: true
    t.string   "title",              limit: 50
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  add_index "tickets", ["created_at"], name: "index_tickets_on_created_at"
  add_index "tickets", ["customer_id"], name: "index_tickets_on_customer_id"
  add_index "tickets", ["employee_id"], name: "index_tickets_on_employee_id"
  add_index "tickets", ["ticket_category_id"], name: "index_tickets_on_ticket_category_id"
  add_index "tickets", ["ticket_status_id"], name: "index_tickets_on_ticket_status_id"

end
