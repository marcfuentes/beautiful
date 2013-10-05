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

ActiveRecord::Schema.define(:version => 20131001032535) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "categories_products", :id => false, :force => true do |t|
    t.integer "categories_id"
    t.integer "product_id"
  end

  add_index "categories_products", ["categories_id", "product_id"], :name => "index_categories_products_on_categories_id_and_product_id"

  create_table "families", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "families_products", :id => false, :force => true do |t|
    t.integer "family_id"
    t.integer "product_id"
  end

  add_index "families_products", ["family_id", "product_id"], :name => "index_families_products_on_family_id_and_product_id"

  create_table "models", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "models", ["email"], :name => "index_models_on_email", :unique => true
  add_index "models", ["reset_password_token"], :name => "index_models_on_reset_password_token", :unique => true

  create_table "products", :force => true do |t|
    t.string   "name"
    t.float    "price"
    t.float    "tva"
    t.text     "description"
    t.boolean  "visible"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "family_id"
  end

  add_index "products", ["family_id"], :name => "index_products_on_family_id"

  create_table "trabajadors", :force => true do |t|
    t.integer  "rut"
    t.string   "nombre"
    t.string   "materno"
    t.string   "paterno"
    t.string   "perfil"
    t.string   "profesion"
    t.string   "email"
    t.integer  "sueldo"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
