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

ActiveRecord::Schema.define(version: 20150401203207) do

  create_table "dependencies", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "parent_id"
    t.integer  "master_unit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", force: true do |t|
    t.string   "description"
    t.text     "observation"
    t.string   "code"
    t.integer  "direction"
    t.string   "system_status"
    t.date     "emission_date"
    t.datetime "entry_at"
    t.string   "reference_people"
    t.string   "recipients"
    t.string   "senders"
    t.integer  "create_user_id_id"
    t.integer  "entry_user_id_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "indident_number"
    t.string   "resolution_number"
  end

  add_index "documents", ["create_user_id_id"], name: "index_documents_on_create_user_id_id", using: :btree
  add_index "documents", ["entry_user_id_id"], name: "index_documents_on_entry_user_id_id", using: :btree

  create_table "employments", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entities", force: true do |t|
    t.integer  "person_id"
    t.integer  "employment_id"
    t.integer  "dependency_id"
    t.boolean  "active"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "entities", ["dependency_id"], name: "index_entities_on_dependency_id", using: :btree
  add_index "entities", ["employment_id"], name: "index_entities_on_employment_id", using: :btree
  add_index "entities", ["person_id"], name: "index_entities_on_person_id", using: :btree
  add_index "entities", ["user_id"], name: "index_entities_on_user_id", using: :btree

  create_table "folders", force: true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "folders", ["parent_id"], name: "index_folders_on_parent_id", using: :btree

  create_table "master_units", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", force: true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "references", force: true do |t|
    t.integer  "document_id"
    t.integer  "entity_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "references", ["document_id"], name: "index_references_on_document_id", using: :btree
  add_index "references", ["entity_id"], name: "index_references_on_entity_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
