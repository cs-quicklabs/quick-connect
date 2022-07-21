# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_08_09_044878) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "activities", force: :cascade do |t|
    t.string "name"
    t.bigint "account_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "default", default: false, null: false
    t.index ["account_id"], name: "index_activities_on_account_id"
    t.index ["group_id"], name: "index_activities_on_group_id"
  end

  create_table "comments", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id", null: false
    t.bigint "journal_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["journal_id"], name: "index_comments_on_journal_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "contact_activities", force: :cascade do |t|
    t.string "title"
    t.string "body"
    t.date "date", default: -> { "CURRENT_DATE" }, null: false
    t.bigint "activity_id", null: false
    t.bigint "contact_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_contact_activities_on_activity_id"
    t.index ["contact_id"], name: "index_contact_activities_on_contact_id"
    t.index ["user_id"], name: "index_contact_activities_on_user_id"
  end

  create_table "contact_events", force: :cascade do |t|
    t.string "title"
    t.string "body"
    t.date "date", default: -> { "CURRENT_DATE" }, null: false
    t.bigint "life_event_id", null: false
    t.bigint "contact_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_contact_events_on_contact_id"
    t.index ["life_event_id"], name: "index_contact_events_on_life_event_id"
    t.index ["user_id"], name: "index_contact_events_on_user_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "email", default: ""
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "phone", default: "", null: false
    t.datetime "birthday"
    t.string "address", default: ""
    t.string "about", default: ""
    t.bigint "user_id"
    t.bigint "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "relation_id"
    t.boolean "archived", default: false
    t.date "archived_on"
    t.index ["account_id"], name: "index_contacts_on_account_id"
    t.index ["first_name"], name: "index_contacts_on_first_name"
    t.index ["relation_id"], name: "index_contacts_on_relation_id"
    t.index ["user_id"], name: "index_contacts_on_user_id"
  end

  create_table "contacts_labels", id: false, force: :cascade do |t|
    t.bigint "contact_id", null: false
    t.bigint "label_id", null: false
  end

  create_table "conversations", force: :cascade do |t|
    t.text "body"
    t.bigint "contact_id"
    t.bigint "user_id"
    t.bigint "field_id"
    t.date "date", default: -> { "CURRENT_DATE" }, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_conversations_on_contact_id"
    t.index ["field_id"], name: "index_conversations_on_field_id"
    t.index ["user_id"], name: "index_conversations_on_user_id"
  end

  create_table "debts", force: :cascade do |t|
    t.string "title"
    t.string "amount"
    t.string "owed_by", default: "user", null: false
    t.bigint "user_id"
    t.bigint "contact_id"
    t.datetime "due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_debts_on_contact_id"
    t.index ["user_id"], name: "index_debts_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.integer "user_id"
    t.string "action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "action_for_context"
    t.integer "trackable_id"
    t.string "trackable_type"
    t.integer "eventable_id"
    t.string "eventable_type"
    t.bigint "account_id", null: false
    t.string "action_context"
    t.index ["account_id"], name: "index_events_on_account_id"
  end

  create_table "fields", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "name", null: false
    t.string "protocol"
    t.string "icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "default", default: false, null: false
    t.index ["account_id"], name: "index_fields_on_account_id"
  end

  create_table "gifts", force: :cascade do |t|
    t.string "name"
    t.text "body"
    t.string "status", default: "true"
    t.bigint "user_id"
    t.bigint "contact_id"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_gifts_on_contact_id"
    t.index ["user_id"], name: "index_gifts_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category", default: "activity", null: false
  end

  create_table "journals", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "body"
    t.integer "account_id"
    t.index ["user_id"], name: "index_journals_on_user_id"
  end

  create_table "jwt_denylist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", precision: nil, null: false
    t.index ["jti"], name: "index_jwt_denylist_on_jti"
  end

  create_table "labels", force: :cascade do |t|
    t.string "name"
    t.string "color", default: "gray", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_labels_on_account_id"
  end

  create_table "life_events", force: :cascade do |t|
    t.string "name"
    t.bigint "account_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "default", default: false, null: false
    t.index ["account_id"], name: "index_life_events_on_account_id"
    t.index ["group_id"], name: "index_life_events_on_group_id"
  end

  create_table "notes", id: false, force: :cascade do |t|
    t.text "body"
    t.bigint "contact_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", default: ""
    t.bigint "user_id"
    t.index ["contact_id"], name: "index_notes_on_contact_id"
  end

  create_table "pay_charges", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.integer "subscription_id"
    t.string "processor_id", null: false
    t.integer "amount", null: false
    t.string "currency"
    t.integer "application_fee_amount"
    t.integer "amount_refunded"
    t.jsonb "metadata"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id", "processor_id"], name: "index_pay_charges_on_customer_id_and_processor_id", unique: true
    t.index ["subscription_id"], name: "index_pay_charges_on_subscription_id"
  end

  create_table "pay_customers", force: :cascade do |t|
    t.string "owner_type"
    t.integer "owner_id"
    t.string "processor", null: false
    t.string "processor_id"
    t.boolean "default"
    t.jsonb "data"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id", "deleted_at", "default"], name: "pay_customer_owner_index"
    t.index ["processor", "processor_id"], name: "index_pay_customers_on_processor_and_processor_id", unique: true
  end

  create_table "pay_merchants", force: :cascade do |t|
    t.string "owner_type"
    t.integer "owner_id"
    t.string "processor", null: false
    t.string "processor_id"
    t.boolean "default"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id", "processor"], name: "index_pay_merchants_on_owner_type_and_owner_id_and_processor"
  end

  create_table "pay_payment_methods", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.string "processor_id", null: false
    t.boolean "default"
    t.string "type"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id", "processor_id"], name: "index_pay_payment_methods_on_customer_id_and_processor_id", unique: true
  end

  create_table "pay_subscriptions", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.string "name", null: false
    t.string "processor_id", null: false
    t.string "processor_plan", null: false
    t.integer "quantity", default: 1, null: false
    t.string "status", null: false
    t.datetime "trial_ends_at", precision: nil
    t.datetime "ends_at", precision: nil
    t.decimal "application_fee_percent", precision: 8, scale: 2
    t.jsonb "metadata"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id", "processor_id"], name: "index_pay_subscriptions_on_customer_id_and_processor_id", unique: true
  end

  create_table "pay_webhooks", force: :cascade do |t|
    t.string "processor"
    t.string "event_type"
    t.jsonb "event"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "phone_calls", force: :cascade do |t|
    t.text "body"
    t.bigint "contact_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date", default: -> { "CURRENT_DATE" }, null: false
    t.string "status", default: "contact", null: false
    t.index ["contact_id"], name: "index_phone_calls_on_contact_id"
    t.index ["user_id"], name: "index_phone_calls_on_user_id"
  end

  create_table "preferences", force: :cascade do |t|
    t.string "key"
    t.string "value"
    t.string "title"
    t.string "message"
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_preferences_on_account_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.integer "rating", default: 1, null: false
    t.bigint "user_id"
    t.date "date", default: -> { "CURRENT_DATE" }, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_id"
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "relations", force: :cascade do |t|
    t.string "name"
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "default", default: false, null: false
    t.index ["account_id"], name: "index_relations_on_account_id"
  end

  create_table "relatives", force: :cascade do |t|
    t.string "name"
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "first_contact_id"
    t.integer "relation_id"
    t.integer "contact_id"
    t.index ["account_id"], name: "index_relatives_on_account_id"
  end

  create_table "release_notes", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "published", default: false
    t.index ["user_id"], name: "index_release_notes_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.bigint "contact_id"
    t.bigint "user_id"
    t.datetime "due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "completed", default: false
    t.index ["contact_id"], name: "index_tasks_on_contact_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id"
    t.boolean "email_enabled", default: true
    t.string "jti", null: false
    t.integer "permission", default: 0, null: false
    t.index ["account_id"], name: "index_users_on_account_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["user_id"], name: "index_users_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "activities", "accounts"
  add_foreign_key "activities", "groups"
  add_foreign_key "comments", "journals"
  add_foreign_key "comments", "users"
  add_foreign_key "contact_activities", "activities"
  add_foreign_key "contact_activities", "contacts"
  add_foreign_key "contact_activities", "users"
  add_foreign_key "contact_events", "contacts"
  add_foreign_key "contact_events", "life_events"
  add_foreign_key "contact_events", "users"
  add_foreign_key "contacts", "accounts"
  add_foreign_key "contacts", "relations"
  add_foreign_key "contacts", "users"
  add_foreign_key "conversations", "contacts"
  add_foreign_key "conversations", "fields"
  add_foreign_key "conversations", "users"
  add_foreign_key "debts", "contacts"
  add_foreign_key "debts", "users"
  add_foreign_key "events", "accounts"
  add_foreign_key "fields", "accounts"
  add_foreign_key "gifts", "contacts"
  add_foreign_key "gifts", "users"
  add_foreign_key "journals", "users"
  add_foreign_key "labels", "accounts"
  add_foreign_key "life_events", "accounts"
  add_foreign_key "life_events", "groups"
  add_foreign_key "notes", "contacts"
  add_foreign_key "pay_charges", "pay_customers", column: "customer_id"
  add_foreign_key "pay_charges", "pay_subscriptions", column: "subscription_id"
  add_foreign_key "pay_payment_methods", "pay_customers", column: "customer_id"
  add_foreign_key "pay_subscriptions", "pay_customers", column: "customer_id"
  add_foreign_key "phone_calls", "contacts"
  add_foreign_key "phone_calls", "users"
  add_foreign_key "preferences", "accounts"
  add_foreign_key "ratings", "users"
  add_foreign_key "relations", "accounts"
  add_foreign_key "relatives", "accounts"
  add_foreign_key "release_notes", "users"
  add_foreign_key "tasks", "contacts"
  add_foreign_key "tasks", "users"
  add_foreign_key "users", "accounts"
  add_foreign_key "users", "users"
end
