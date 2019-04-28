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

ActiveRecord::Schema.define(version: 2019_04_27_111623) do

  create_table "administrators", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_administrators_on_email", unique: true
    t.index ["reset_password_token"], name: "index_administrators_on_reset_password_token", unique: true
  end

  create_table "analytics", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "project_id"
    t.integer "uniq_request", default: 0
    t.integer "total_request", default: 0
    t.integer "total_bytes", default: 0
    t.bigint "last_image_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_analytics_on_project_id"
    t.index ["user_id"], name: "index_analytics_on_user_id"
  end

  create_table "folders", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "project_id"
    t.bigint "folder_id"
    t.boolean "is_file"
    t.string "name"
    t.string "path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["folder_id"], name: "index_folders_on_folder_id"
    t.index ["path"], name: "index_folders_on_path", unique: true
    t.index ["project_id"], name: "index_folders_on_project_id"
    t.index ["user_id", "project_id", "path"], name: "index_uniq_key", unique: true
    t.index ["user_id"], name: "index_folders_on_user_id"
  end

  create_table "images", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "project_id"
    t.string "key"
    t.string "origin"
    t.string "origin_path"
    t.string "transformation"
    t.boolean "is_smart"
    t.string "cdn_path"
    t.integer "file_size", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "host_domain", default: "imagetransform.io"
    t.index ["key"], name: "index_images_on_key", unique: true
    t.index ["origin", "origin_path", "transformation", "is_smart"], name: "index_uniq_path", unique: true
    t.index ["project_id"], name: "index_images_on_project_id"
    t.index ["user_id"], name: "index_images_on_user_id"
  end

  create_table "invoices", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "user_id"
    t.string "status"
    t.string "subject"
    t.text "body"
    t.datetime "duedate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_invoices_on_user_id"
  end

  create_table "messages", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "message_id"
    t.bigint "project_id"
    t.string "status"
    t.string "priority", default: "Low"
    t.string "subject"
    t.text "body"
    t.boolean "support_call"
    t.boolean "user_call"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_messages_on_message_id"
    t.index ["project_id"], name: "index_messages_on_project_id"
    t.index ["support_call"], name: "index_messages_on_support_call"
    t.index ["user_call"], name: "index_messages_on_user_call"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "projects", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.string "uuid"
    t.string "fqdn"
    t.string "base_path", default: ""
    t.string "protocol", limit: 5, default: "https"
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "default_host_domain", default: "imagetransform.io"
    t.index ["fqdn"], name: "index_projects_on_fqdn", unique: true
    t.index ["user_id"], name: "index_projects_on_user_id"
    t.index ["uuid"], name: "index_projects_on_uuid", unique: true
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "plan", default: 0
    t.boolean "is_support", default: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "analytics", "projects"
  add_foreign_key "analytics", "users"
  add_foreign_key "folders", "folders"
  add_foreign_key "folders", "projects"
  add_foreign_key "folders", "users"
  add_foreign_key "images", "projects"
  add_foreign_key "images", "users"
  add_foreign_key "invoices", "users"
  add_foreign_key "messages", "messages"
  add_foreign_key "messages", "projects"
  add_foreign_key "messages", "users"
  add_foreign_key "projects", "users"
end
