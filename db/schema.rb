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

ActiveRecord::Schema.define(version: 20170709124545) do

  create_table "bugs", force: true do |t|
    t.string   "title"
    t.string   "name"
    t.string   "email"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities", force: true do |t|
    t.string   "name"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "latitude"
    t.string   "longitude"
    t.boolean  "capital",       default: false
    t.integer  "mapbox_obj_id"
  end

  create_table "countries", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "latitude"
    t.string   "longitude"
    t.integer  "population"
  end

  create_table "countries_codes", id: false, force: true do |t|
    t.string   "country_code", limit: 3
    t.string   "country_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "population"
  end

  create_table "countries_stats", id: false, force: true do |t|
    t.string   "country_code"
    t.string   "income"
    t.integer  "population"
    t.integer  "surgeons"
    t.integer  "obstetricians"
    t.integer  "anesthesiologists"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "districts", force: true do |t|
    t.string   "name"
    t.integer  "mapbox_obj_id"
    t.integer  "country_id"
    t.integer  "est_population"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "doctors", force: true do |t|
    t.string   "title"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "email"
    t.integer  "fellow_type_id"
    t.string   "gender"
    t.integer  "specialty_id"
    t.integer  "city_id"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organisation_id"
    t.text     "qualification"
    t.integer  "user_id"
  end

  create_table "fellow_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ngos", force: true do |t|
    t.string   "organization_name"
    t.string   "contact_email"
    t.string   "website"
    t.string   "surgery_focused",     limit: 1
    t.string   "permanent_hospital",  limit: 1
    t.string   "self_contained",      limit: 1
    t.string   "short_term",          limit: 1
    t.string   "long_term",           limit: 1
    t.string   "humanitarian",        limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "hq_city"
    t.string   "hq_cntry_code",       limit: 3
    t.string   "hq_address"
    t.string   "name"
    t.text     "mission"
    t.string   "type"
    t.string   "specialty"
    t.string   "education_yn",        limit: 1
    t.string   "training_yn",         limit: 1
    t.string   "medsupply_yn",        limit: 1
    t.string   "technology_yn",       limit: 1
    t.string   "anaesthesia_focused", limit: 1
    t.string   "obstetrics_focused",  limit: 1
    t.string   "internal_yn",         limit: 1, default: "N"
    t.string   "alt_email"
    t.text     "person_role"
  end

  create_table "ngos_branches", id: false, force: true do |t|
    t.integer "organization_id",           default: 0,  null: false
    t.string  "country_code",    limit: 3, default: "", null: false
  end

  create_table "ngos_engagement", id: false, force: true do |t|
    t.integer "organization_id",           default: 0,  null: false
    t.string  "country_code",    limit: 3, default: "", null: false
  end

  create_table "ngos_specialties", id: false, force: true do |t|
    t.integer "organization_id", default: 0, null: false
    t.integer "specialty_id",    default: 0, null: false
  end

  create_table "organisations", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "latitude"
    t.string   "longitude"
    t.string   "training",   limit: 1
    t.integer  "city_id"
  end

  create_table "pbcatcol", id: false, force: true do |t|
    t.string  "pbc_tnam", limit: 193, null: false
    t.integer "pbc_tid"
    t.string  "pbc_ownr", limit: 193, null: false
    t.string  "pbc_cnam", limit: 193, null: false
    t.integer "pbc_cid",  limit: 2
    t.string  "pbc_labl", limit: 254
    t.integer "pbc_lpos", limit: 2
    t.string  "pbc_hdr",  limit: 254
    t.integer "pbc_hpos", limit: 2
    t.integer "pbc_jtfy", limit: 2
    t.string  "pbc_mask", limit: 31
    t.integer "pbc_case", limit: 2
    t.integer "pbc_hght", limit: 2
    t.integer "pbc_wdth", limit: 2
    t.string  "pbc_ptrn", limit: 31
    t.string  "pbc_bmap", limit: 1
    t.string  "pbc_init", limit: 254
    t.string  "pbc_cmnt", limit: 254
    t.string  "pbc_edit", limit: 31
    t.string  "pbc_tag",  limit: 254
  end

  add_index "pbcatcol", ["pbc_tnam", "pbc_ownr", "pbc_cnam"], name: "pbcatc_x", unique: true, using: :btree

  create_table "pbcatedt", id: false, force: true do |t|
    t.string  "pbe_name", limit: 30,  null: false
    t.string  "pbe_edit", limit: 254
    t.integer "pbe_type", limit: 2
    t.integer "pbe_cntr"
    t.integer "pbe_seqn", limit: 2,   null: false
    t.integer "pbe_flag"
    t.string  "pbe_work", limit: 32
  end

  add_index "pbcatedt", ["pbe_name", "pbe_seqn"], name: "pbcate_x", unique: true, using: :btree

  create_table "pbcatfmt", id: false, force: true do |t|
    t.string  "pbf_name", limit: 30,  null: false
    t.string  "pbf_frmt", limit: 254
    t.integer "pbf_type", limit: 2
    t.integer "pbf_cntr"
  end

  add_index "pbcatfmt", ["pbf_name"], name: "pbcatf_x", unique: true, using: :btree

  create_table "pbcattbl", id: false, force: true do |t|
    t.string  "pbt_tnam", limit: 193, null: false
    t.integer "pbt_tid"
    t.string  "pbt_ownr", limit: 193, null: false
    t.integer "pbd_fhgt", limit: 2
    t.integer "pbd_fwgt", limit: 2
    t.string  "pbd_fitl", limit: 1
    t.string  "pbd_funl", limit: 1
    t.integer "pbd_fchr", limit: 2
    t.integer "pbd_fptc", limit: 2
    t.string  "pbd_ffce", limit: 18
    t.integer "pbh_fhgt", limit: 2
    t.integer "pbh_fwgt", limit: 2
    t.string  "pbh_fitl", limit: 1
    t.string  "pbh_funl", limit: 1
    t.integer "pbh_fchr", limit: 2
    t.integer "pbh_fptc", limit: 2
    t.string  "pbh_ffce", limit: 18
    t.integer "pbl_fhgt", limit: 2
    t.integer "pbl_fwgt", limit: 2
    t.string  "pbl_fitl", limit: 1
    t.string  "pbl_funl", limit: 1
    t.integer "pbl_fchr", limit: 2
    t.integer "pbl_fptc", limit: 2
    t.string  "pbl_ffce", limit: 18
    t.string  "pbt_cmnt", limit: 254
  end

  add_index "pbcattbl", ["pbt_tnam", "pbt_ownr"], name: "pbcatt_x", unique: true, using: :btree

  create_table "pbcatvld", id: false, force: true do |t|
    t.string  "pbv_name", limit: 30,  null: false
    t.string  "pbv_vald", limit: 254
    t.integer "pbv_type", limit: 2
    t.integer "pbv_cntr"
    t.string  "pbv_msg",  limit: 254
  end

  add_index "pbcatvld", ["pbv_name"], name: "pbcatv_x", unique: true, using: :btree

  create_table "specialties", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stories", force: true do |t|
    t.string   "title"
    t.text     "story"
    t.string   "iconclass"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order",      default: 0, null: false
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

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
    t.string   "role"
    t.string   "username"
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
