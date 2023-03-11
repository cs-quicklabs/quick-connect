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

ActiveRecord::Schema[7.0].define(version: 202120730073156) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abouts", force: :cascade do |t|
    t.string "address", default: ""
    t.string "breif", default: ""
    t.string "met", default: ""
    t.string "habit", default: ""
    t.string "work", default: ""
    t.string "other", default: ""
    t.bigint "contact_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "owner_id"
    t.boolean "expired", default: false, null: false
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
  end

  create_table "activities", force: :cascade do |t|
    t.string "name"
    t.bigint "account_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "default", default: false, null: false
  end

  create_table "batches", force: :cascade do |t|
    t.string "name"
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "batches_contacts", id: false, force: :cascade do |t|
    t.bigint "contact_id", null: false
    t.bigint "batch_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["contact_id", "batch_id"], name: "index_batches_contacts_on_contact_id_and_batch_id", unique: true
  end

  create_table "comments", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id", null: false
    t.bigint "journal_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "contact_activities", force: :cascade do |t|
    t.string "title"
    t.string "body"
    t.date "date", default: -> { "CURRENT_DATE" }, null: false
    t.bigint "activity_id", null: false
    t.bigint "contact_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "contact_events", force: :cascade do |t|
    t.string "title"
    t.string "body"
    t.date "date", default: -> { "CURRENT_DATE" }, null: false
    t.bigint "life_event_id", null: false
    t.bigint "contact_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string "email", default: ""
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "phone", default: ""
    t.datetime "birthday", precision: nil
    t.string "address", default: ""
    t.string "about", default: ""
    t.bigint "user_id"
    t.bigint "account_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "archived", default: false
    t.date "archived_on"
    t.bigint "relation_id"
    t.boolean "favorite", default: false, null: false
    t.boolean "track", default: true, null: false
    t.date "untrack_on"
    t.string "intro"
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "debts", force: :cascade do |t|
    t.string "title"
    t.string "amount"
    t.string "owed_by", default: "user"
    t.bigint "user_id"
    t.bigint "contact_id"
    t.datetime "due_date", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "documents", force: :cascade do |t|
    t.string "filename"
    t.string "link"
    t.string "comments"
    t.bigint "user_id"
    t.bigint "contact_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "events", force: :cascade do |t|
    t.integer "user_id"
    t.string "action"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "action_for_context"
    t.integer "trackable_id"
    t.string "trackable_type"
    t.integer "eventable_id"
    t.string "eventable_type"
    t.bigint "account_id", null: false
    t.string "action_context"
  end

  create_table "fields", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "name", null: false
    t.string "protocol"
    t.string "icon"
    t.boolean "type", default: false, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "default", default: false, null: false
  end

  create_table "gifts", force: :cascade do |t|
    t.string "name"
    t.text "body"
    t.string "status", default: "received"
    t.bigint "user_id"
    t.bigint "contact_id"
    t.datetime "date", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "category", default: "activity", null: false
  end

  create_table "invitations", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "account_id"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "token"
    t.datetime "sent_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "sender_id"
  end

  create_table "journals", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "body", null: false
    t.integer "account_id"
  end

  create_table "labels", force: :cascade do |t|
    t.string "name"
    t.string "color", default: "gray", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "life_events", force: :cascade do |t|
    t.string "name"
    t.bigint "account_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "default", default: false, null: false
  end

  create_table "links", force: :cascade do |t|
    t.string "link"
    t.string "link_type"
    t.bigint "user_id"
    t.bigint "contact_id"
    t.index ["contact_id"], name: "index_links_on_contact_id"
    t.index ["user_id"], name: "index_links_on_user_id"
  end

  create_table "notes", force: :cascade do |t|
    t.text "body"
    t.bigint "contact_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "title", default: ""
  end

  create_table "pay_charges", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "subscription_id"
    t.string "processor_id", null: false
    t.integer "amount", null: false
    t.string "currency"
    t.integer "application_fee_amount"
    t.integer "amount_refunded"
    t.jsonb "metadata"
    t.jsonb "data"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "pay_customers", force: :cascade do |t|
    t.string "owner_type"
    t.bigint "owner_id"
    t.string "processor", null: false
    t.string "processor_id"
    t.boolean "default"
    t.jsonb "data"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "pay_merchants", force: :cascade do |t|
    t.string "owner_type"
    t.bigint "owner_id"
    t.string "processor", null: false
    t.string "processor_id"
    t.boolean "default"
    t.jsonb "data"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "pay_payment_methods", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.string "processor_id", null: false
    t.boolean "default"
    t.string "type"
    t.jsonb "data"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "pay_subscriptions", force: :cascade do |t|
    t.bigint "customer_id", null: false
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.datetime "current_period_start"
    t.datetime "current_period_end"
    t.boolean "metered"
    t.string "pause_behavior"
    t.datetime "pause_starts_at"
    t.datetime "pause_resumes_at"
    t.index ["metered"], name: "index_pay_subscriptions_on_metered"
    t.index ["pause_starts_at"], name: "index_pay_subscriptions_on_pause_starts_at"
  end

  create_table "pay_webhooks", force: :cascade do |t|
    t.string "processor"
    t.string "event_type"
    t.jsonb "event"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "phone_calls", force: :cascade do |t|
    t.text "body"
    t.bigint "contact_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.date "date", default: -> { "CURRENT_DATE" }, null: false
    t.string "status", default: "contact", null: false
  end

  create_table "preferences", force: :cascade do |t|
    t.string "key"
    t.string "value"
    t.string "title"
    t.string "message"
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "ratings", force: :cascade do |t|
    t.integer "rating", default: 1, null: false
    t.bigint "user_id"
    t.date "date", default: -> { "CURRENT_DATE" }, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "account_id"
  end

  create_table "relations", force: :cascade do |t|
    t.string "name"
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "default", default: false, null: false
  end

  create_table "relatives", force: :cascade do |t|
    t.string "name"
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "first_contact_id"
    t.integer "relation_id"
    t.integer "contact_id"
  end

  create_table "reminders", force: :cascade do |t|
    t.string "title"
    t.integer "reminder_type"
    t.integer "status"
    t.integer "remind_after"
    t.date "reminder_date"
    t.string "comments"
    t.bigint "user_id"
    t.bigint "contact_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "account_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.bigint "contact_id"
    t.bigint "user_id"
    t.datetime "due_date", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "completed", default: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.bigint "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "permission", default: 0, null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at", precision: nil
    t.datetime "invitation_sent_at", precision: nil
    t.datetime "invitation_accepted_at", precision: nil
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.bigint "account_id"
    t.boolean "email_enabled", default: true
    t.string "jti", null: false
    t.integer "admin", default: 0, null: false
  end

  add_foreign_key "abouts", "contacts", name: "abouts_contact_id_fkey"
  add_foreign_key "abouts", "users", name: "abouts_user_id_fkey"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id", name: "active_storage_attachments_blob_id_fkey"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id", name: "active_storage_variant_records_blob_id_fkey"
  add_foreign_key "activities", "accounts", name: "activities_account_id_fkey"
  add_foreign_key "activities", "groups", name: "activities_group_id_fkey"
  add_foreign_key "batches", "accounts", name: "batches_account_id_fkey"
  add_foreign_key "comments", "journals", name: "comments_journal_id_fkey"
  add_foreign_key "comments", "users", name: "comments_user_id_fkey"
  add_foreign_key "contact_activities", "activities", name: "contact_activities_activity_id_fkey"
  add_foreign_key "contact_activities", "contacts", name: "contact_activities_contact_id_fkey"
  add_foreign_key "contact_activities", "users", name: "contact_activities_user_id_fkey"
  add_foreign_key "contact_events", "contacts", name: "contact_events_contact_id_fkey"
  add_foreign_key "contact_events", "life_events", name: "contact_events_life_event_id_fkey"
  add_foreign_key "contact_events", "users", name: "contact_events_user_id_fkey"
  add_foreign_key "contacts", "accounts", name: "contacts_account_id_fkey"
  add_foreign_key "contacts", "relations", name: "contacts_relation_id_fkey"
  add_foreign_key "contacts", "users", name: "contacts_user_id_fkey"
  add_foreign_key "conversations", "contacts", name: "conversations_contact_id_fkey"
  add_foreign_key "conversations", "fields", name: "conversations_field_id_fkey"
  add_foreign_key "conversations", "users", name: "conversations_user_id_fkey"
  add_foreign_key "debts", "contacts", name: "debts_contact_id_fkey"
  add_foreign_key "debts", "users", name: "debts_user_id_fkey"
  add_foreign_key "documents", "contacts", name: "documents_contact_id_fkey"
  add_foreign_key "documents", "users", name: "documents_user_id_fkey"
  add_foreign_key "events", "accounts", name: "events_account_id_fkey"
  add_foreign_key "fields", "accounts", name: "fields_account_id_fkey"
  add_foreign_key "gifts", "contacts", name: "gifts_contact_id_fkey"
  add_foreign_key "gifts", "users", name: "gifts_user_id_fkey"
  add_foreign_key "invitations", "accounts", name: "invitations_account_id_fkey"
  add_foreign_key "invitations", "users", name: "invitations_user_id_fkey"
  add_foreign_key "journals", "users", name: "journals_user_id_fkey"
  add_foreign_key "labels", "accounts", name: "labels_account_id_fkey"
  add_foreign_key "life_events", "accounts", name: "life_events_account_id_fkey"
  add_foreign_key "life_events", "groups", name: "life_events_group_id_fkey"
  add_foreign_key "links", "contacts"
  add_foreign_key "links", "users"
  add_foreign_key "notes", "contacts", name: "notes_contact_id_fkey"
  add_foreign_key "notes", "users", name: "notes_user_id_fkey"
  add_foreign_key "pay_charges", "pay_customers", column: "customer_id", name: "pay_charges_customer_id_fkey"
  add_foreign_key "pay_charges", "pay_subscriptions", column: "subscription_id", name: "pay_charges_subscription_id_fkey"
  add_foreign_key "pay_payment_methods", "pay_customers", column: "customer_id", name: "pay_payment_methods_customer_id_fkey"
  add_foreign_key "pay_subscriptions", "pay_customers", column: "customer_id", name: "pay_subscriptions_customer_id_fkey"
  add_foreign_key "phone_calls", "contacts", name: "phone_calls_contact_id_fkey"
  add_foreign_key "phone_calls", "users", name: "phone_calls_user_id_fkey"
  add_foreign_key "preferences", "accounts", name: "preferences_account_id_fkey"
  add_foreign_key "ratings", "users", name: "ratings_user_id_fkey"
  add_foreign_key "relations", "accounts", name: "relations_account_id_fkey"
  add_foreign_key "relatives", "accounts", name: "relatives_account_id_fkey"
  add_foreign_key "reminders", "accounts", name: "reminders_account_id_fkey"
  add_foreign_key "reminders", "contacts", name: "reminders_contact_id_fkey"
  add_foreign_key "reminders", "users", name: "reminders_user_id_fkey"
  add_foreign_key "tasks", "contacts", name: "tasks_contact_id_fkey"
  add_foreign_key "tasks", "users", name: "tasks_user_id_fkey"
  add_foreign_key "users", "accounts", name: "users_account_id_fkey"
  add_foreign_key "users", "users", name: "users_user_id_fkey"
end
