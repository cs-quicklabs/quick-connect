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

ActiveRecord::Schema[8.1].define(version: 2025_05_31_055216) do
  create_table "abouts", force: :cascade do |t|
    t.string "address", default: ""
    t.string "breif", default: ""
    t.integer "contact_id", null: false
    t.datetime "created_at", null: false
    t.string "habit", default: ""
    t.string "met", default: ""
    t.string "other", default: ""
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.string "work", default: ""
    t.index ["contact_id"], name: "index_abouts_on_contact_id"
    t.index ["user_id"], name: "index_abouts_on_user_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "expired", default: false, null: false
    t.string "name"
    t.integer "owner_id"
    t.datetime "updated_at", null: false
  end

  create_table "activities", force: :cascade do |t|
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.boolean "default", default: false, null: false
    t.integer "group_id", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_activities_on_account_id"
    t.index ["group_id"], name: "index_activities_on_group_id"
  end

  create_table "batches", force: :cascade do |t|
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_batches_on_account_id"
  end

  create_table "batches_collections", id: false, force: :cascade do |t|
    t.integer "batch_id", null: false
    t.integer "collection_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "batches_contacts", id: false, force: :cascade do |t|
    t.integer "batch_id", null: false
    t.integer "contact_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id", "batch_id"], name: "index_batches_contacts_on_contact_id_and_batch_id", unique: true
  end

  create_table "collections", force: :cascade do |t|
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_collections_on_account_id"
  end

  create_table "contact_activities", force: :cascade do |t|
    t.integer "activity_id", null: false
    t.string "body"
    t.integer "contact_id", null: false
    t.datetime "created_at", null: false
    t.date "date", default: -> { "CURRENT_DATE" }, null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["activity_id"], name: "index_contact_activities_on_activity_id"
    t.index ["contact_id"], name: "index_contact_activities_on_contact_id"
    t.index ["user_id"], name: "index_contact_activities_on_user_id"
  end

  create_table "contact_events", force: :cascade do |t|
    t.string "body"
    t.integer "contact_id", null: false
    t.datetime "created_at", null: false
    t.date "date", default: -> { "CURRENT_DATE" }, null: false
    t.integer "life_event_id", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["contact_id"], name: "index_contact_events_on_contact_id"
    t.index ["life_event_id"], name: "index_contact_events_on_life_event_id"
    t.index ["user_id"], name: "index_contact_events_on_user_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "about", default: ""
    t.integer "account_id"
    t.integer "activity_count", default: 0
    t.string "address", default: ""
    t.boolean "archived", default: false
    t.date "archived_on"
    t.datetime "birthday"
    t.datetime "created_at", null: false
    t.string "email", default: ""
    t.boolean "favorite", default: false, null: false
    t.string "first_name", default: "", null: false
    t.date "followup_after_changed_on"
    t.string "intro"
    t.string "last_name", default: "", null: false
    t.string "phone", default: ""
    t.integer "relation_id"
    t.integer "touch_back_after", default: 0
    t.date "touched_at"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["account_id"], name: "index_contacts_on_account_id"
    t.index ["first_name"], name: "index_contacts_on_first_name"
    t.index ["relation_id"], name: "index_contacts_on_relation_id"
    t.index ["user_id"], name: "index_contacts_on_user_id"
  end

  create_table "contacts_labels", id: false, force: :cascade do |t|
    t.integer "contact_id", null: false
    t.integer "label_id", null: false
  end

  create_table "conversations", force: :cascade do |t|
    t.text "body"
    t.integer "contact_id"
    t.datetime "created_at", null: false
    t.date "date", default: -> { "CURRENT_DATE" }, null: false
    t.integer "field_id"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["contact_id"], name: "index_conversations_on_contact_id"
    t.index ["field_id"], name: "index_conversations_on_field_id"
    t.index ["user_id"], name: "index_conversations_on_user_id"
  end

  create_table "debts", force: :cascade do |t|
    t.string "amount"
    t.integer "contact_id"
    t.datetime "created_at", null: false
    t.datetime "due_date"
    t.string "owed_by", default: "user"
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["contact_id"], name: "index_debts_on_contact_id"
    t.index ["user_id"], name: "index_debts_on_user_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string "comments"
    t.integer "contact_id"
    t.datetime "created_at", null: false
    t.string "filename"
    t.string "link"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["contact_id"], name: "index_documents_on_contact_id"
    t.index ["user_id"], name: "index_documents_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.integer "account_id", null: false
    t.string "action"
    t.string "action_context"
    t.string "action_for_context"
    t.datetime "created_at", null: false
    t.integer "eventable_id"
    t.string "eventable_type"
    t.integer "trackable_id"
    t.string "trackable_type"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["account_id"], name: "index_events_on_account_id"
  end

  create_table "fields", force: :cascade do |t|
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.boolean "default", default: false, null: false
    t.string "icon"
    t.string "name", null: false
    t.string "protocol"
    t.boolean "type", default: false, null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_fields_on_account_id"
  end

  create_table "gifts", force: :cascade do |t|
    t.text "body"
    t.integer "contact_id"
    t.datetime "created_at", null: false
    t.datetime "date"
    t.string "name"
    t.string "status", default: "received"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["contact_id"], name: "index_gifts_on_contact_id"
    t.index ["user_id"], name: "index_gifts_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "category", default: "activity", null: false
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "invitations", force: :cascade do |t|
    t.integer "account_id"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.integer "sender_id"
    t.datetime "sent_at"
    t.string "token"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["account_id"], name: "index_invitations_on_account_id"
    t.index ["user_id"], name: "index_invitations_on_user_id"
  end

  create_table "labels", force: :cascade do |t|
    t.integer "account_id", null: false
    t.string "color", default: "gray", null: false
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_labels_on_account_id"
  end

  create_table "life_events", force: :cascade do |t|
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.boolean "default", default: false, null: false
    t.integer "group_id", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_life_events_on_account_id"
    t.index ["group_id"], name: "index_life_events_on_group_id"
  end

  create_table "links", force: :cascade do |t|
    t.integer "contact_id"
    t.string "link"
    t.string "link_type"
    t.integer "user_id"
    t.index ["contact_id"], name: "index_links_on_contact_id"
    t.index ["user_id"], name: "index_links_on_user_id"
  end

  create_table "notes", force: :cascade do |t|
    t.text "body"
    t.integer "contact_id"
    t.datetime "created_at", null: false
    t.string "title", default: ""
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["contact_id"], name: "index_notes_on_contact_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "pay_charges", force: :cascade do |t|
    t.integer "amount", null: false
    t.integer "amount_refunded"
    t.integer "application_fee_amount"
    t.datetime "created_at", null: false
    t.string "currency"
    t.integer "customer_id", null: false
    t.json "data"
    t.json "metadata"
    t.string "processor_id", null: false
    t.integer "subscription_id"
    t.datetime "updated_at", null: false
    t.index ["customer_id", "processor_id"], name: "index_pay_charges_on_customer_id_and_processor_id", unique: true
    t.index ["subscription_id"], name: "index_pay_charges_on_subscription_id"
  end

  create_table "pay_customers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.json "data"
    t.boolean "default"
    t.datetime "deleted_at", precision: nil
    t.integer "owner_id"
    t.string "owner_type"
    t.string "processor", null: false
    t.string "processor_id"
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id", "deleted_at", "default"], name: "pay_customer_owner_index"
    t.index ["processor", "processor_id"], name: "index_pay_customers_on_processor_and_processor_id", unique: true
  end

  create_table "pay_merchants", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.json "data"
    t.boolean "default"
    t.integer "owner_id"
    t.string "owner_type"
    t.string "processor", null: false
    t.string "processor_id"
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id", "processor"], name: "index_pay_merchants_on_owner_type_and_owner_id_and_processor"
  end

  create_table "pay_payment_methods", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "customer_id", null: false
    t.json "data"
    t.boolean "default"
    t.string "processor_id", null: false
    t.string "type"
    t.datetime "updated_at", null: false
    t.index ["customer_id", "processor_id"], name: "index_pay_payment_methods_on_customer_id_and_processor_id", unique: true
  end

  create_table "pay_subscriptions", force: :cascade do |t|
    t.decimal "application_fee_percent", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.datetime "current_period_end"
    t.datetime "current_period_start"
    t.integer "customer_id", null: false
    t.json "data"
    t.datetime "ends_at", precision: nil
    t.json "metadata"
    t.boolean "metered"
    t.string "name", null: false
    t.string "pause_behavior"
    t.datetime "pause_resumes_at"
    t.datetime "pause_starts_at"
    t.string "processor_id", null: false
    t.string "processor_plan", null: false
    t.integer "quantity", default: 1, null: false
    t.string "status", null: false
    t.datetime "trial_ends_at", precision: nil
    t.datetime "updated_at", null: false
    t.index ["customer_id", "processor_id"], name: "index_pay_subscriptions_on_customer_id_and_processor_id", unique: true
    t.index ["metered"], name: "index_pay_subscriptions_on_metered"
    t.index ["pause_starts_at"], name: "index_pay_subscriptions_on_pause_starts_at"
  end

  create_table "pay_webhooks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.json "event"
    t.string "event_type"
    t.string "processor"
    t.datetime "updated_at", null: false
  end

  create_table "phone_calls", force: :cascade do |t|
    t.text "body"
    t.integer "contact_id"
    t.datetime "created_at", null: false
    t.date "date", default: -> { "CURRENT_DATE" }, null: false
    t.string "status", default: "contact", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["contact_id"], name: "index_phone_calls_on_contact_id"
    t.index ["user_id"], name: "index_phone_calls_on_user_id"
  end

  create_table "preferences", force: :cascade do |t|
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.string "key"
    t.string "message"
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["account_id"], name: "index_preferences_on_account_id"
  end

  create_table "relations", force: :cascade do |t|
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.boolean "default", default: false, null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_relations_on_account_id"
  end

  create_table "relatives", force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "contact_id"
    t.datetime "created_at", null: false
    t.integer "first_contact_id"
    t.string "name"
    t.integer "relation_id"
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_relatives_on_account_id"
  end

  create_table "reminders", force: :cascade do |t|
    t.integer "account_id"
    t.string "comments"
    t.integer "contact_id"
    t.datetime "created_at", null: false
    t.integer "remind_after"
    t.date "reminder_date"
    t.integer "reminder_type"
    t.integer "status"
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["account_id"], name: "index_reminders_on_account_id"
    t.index ["contact_id"], name: "index_reminders_on_contact_id"
    t.index ["user_id"], name: "index_reminders_on_user_id"
  end

  create_table "solid_cache_entries", force: :cascade do |t|
    t.integer "byte_size", limit: 4, null: false
    t.datetime "created_at", null: false
    t.binary "key", limit: 1024, null: false
    t.integer "key_hash", limit: 8, null: false
    t.binary "value", limit: 536870912, null: false
    t.index ["byte_size"], name: "index_solid_cache_entries_on_byte_size"
    t.index ["key_hash", "byte_size"], name: "index_solid_cache_entries_on_key_hash_and_byte_size"
    t.index ["key_hash"], name: "index_solid_cache_entries_on_key_hash", unique: true
  end

  create_table "solid_queue_blocked_executions", force: :cascade do |t|
    t.string "concurrency_key", null: false
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.index ["concurrency_key", "priority", "job_id"], name: "index_solid_queue_blocked_executions_for_release"
    t.index ["expires_at", "concurrency_key"], name: "index_solid_queue_blocked_executions_for_maintenance"
    t.index ["job_id"], name: "index_solid_queue_blocked_executions_on_job_id", unique: true
  end

  create_table "solid_queue_claimed_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.bigint "process_id"
    t.index ["job_id"], name: "index_solid_queue_claimed_executions_on_job_id", unique: true
    t.index ["process_id", "job_id"], name: "index_solid_queue_claimed_executions_on_process_id_and_job_id"
  end

  create_table "solid_queue_failed_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "error"
    t.bigint "job_id", null: false
    t.index ["job_id"], name: "index_solid_queue_failed_executions_on_job_id", unique: true
  end

  create_table "solid_queue_jobs", force: :cascade do |t|
    t.string "active_job_id"
    t.text "arguments"
    t.string "class_name", null: false
    t.string "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "finished_at"
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.datetime "scheduled_at"
    t.datetime "updated_at", null: false
    t.index ["active_job_id"], name: "index_solid_queue_jobs_on_active_job_id"
    t.index ["class_name"], name: "index_solid_queue_jobs_on_class_name"
    t.index ["finished_at"], name: "index_solid_queue_jobs_on_finished_at"
    t.index ["queue_name", "finished_at"], name: "index_solid_queue_jobs_for_filtering"
    t.index ["scheduled_at", "finished_at"], name: "index_solid_queue_jobs_for_alerting"
  end

  create_table "solid_queue_pauses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "queue_name", null: false
    t.index ["queue_name"], name: "index_solid_queue_pauses_on_queue_name", unique: true
  end

  create_table "solid_queue_processes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "hostname"
    t.string "kind", null: false
    t.datetime "last_heartbeat_at", null: false
    t.text "metadata"
    t.string "name", null: false
    t.integer "pid", null: false
    t.bigint "supervisor_id"
    t.index ["last_heartbeat_at"], name: "index_solid_queue_processes_on_last_heartbeat_at"
    t.index ["name", "supervisor_id"], name: "index_solid_queue_processes_on_name_and_supervisor_id", unique: true
    t.index ["supervisor_id"], name: "index_solid_queue_processes_on_supervisor_id"
  end

  create_table "solid_queue_ready_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.index ["job_id"], name: "index_solid_queue_ready_executions_on_job_id", unique: true
    t.index ["priority", "job_id"], name: "index_solid_queue_poll_all"
    t.index ["queue_name", "priority", "job_id"], name: "index_solid_queue_poll_by_queue"
  end

  create_table "solid_queue_recurring_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.datetime "run_at", null: false
    t.string "task_key", null: false
    t.index ["job_id"], name: "index_solid_queue_recurring_executions_on_job_id", unique: true
    t.index ["task_key", "run_at"], name: "index_solid_queue_recurring_executions_on_task_key_and_run_at", unique: true
  end

  create_table "solid_queue_recurring_tasks", force: :cascade do |t|
    t.text "arguments"
    t.string "class_name"
    t.string "command", limit: 2048
    t.datetime "created_at", null: false
    t.text "description"
    t.string "key", null: false
    t.integer "priority", default: 0
    t.string "queue_name"
    t.string "schedule", null: false
    t.boolean "static", default: true, null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_solid_queue_recurring_tasks_on_key", unique: true
    t.index ["static"], name: "index_solid_queue_recurring_tasks_on_static"
  end

  create_table "solid_queue_scheduled_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.datetime "scheduled_at", null: false
    t.index ["job_id"], name: "index_solid_queue_scheduled_executions_on_job_id", unique: true
    t.index ["scheduled_at", "priority", "job_id"], name: "index_solid_queue_dispatch_all"
  end

  create_table "solid_queue_semaphores", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.integer "value", default: 1, null: false
    t.index ["expires_at"], name: "index_solid_queue_semaphores_on_expires_at"
    t.index ["key", "value"], name: "index_solid_queue_semaphores_on_key_and_value"
    t.index ["key"], name: "index_solid_queue_semaphores_on_key", unique: true
  end

  create_table "tasks", force: :cascade do |t|
    t.text "body"
    t.boolean "completed", default: false
    t.integer "contact_id"
    t.datetime "created_at", null: false
    t.datetime "due_date"
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["contact_id"], name: "index_tasks_on_contact_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "account_id"
    t.integer "admin", default: 0, null: false
    t.datetime "confirmation_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.boolean "email_enabled", default: true
    t.string "encrypted_password", default: "", null: false
    t.string "first_name", default: "", null: false
    t.datetime "invitation_accepted_at", precision: nil
    t.datetime "invitation_created_at", precision: nil
    t.integer "invitation_limit"
    t.datetime "invitation_sent_at", precision: nil
    t.string "invitation_token"
    t.integer "invitations_count", default: 0
    t.integer "invited_by_id"
    t.string "invited_by_type"
    t.string "jti", null: false
    t.string "last_name", default: "", null: false
    t.datetime "last_sign_in_at", precision: nil
    t.string "last_sign_in_ip"
    t.integer "permission", default: 0, null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0, null: false
    t.string "unconfirmed_email"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["account_id"], name: "index_users_on_account_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by"
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["user_id"], name: "index_users_on_user_id"
  end

  add_foreign_key "abouts", "contacts"
  add_foreign_key "abouts", "users"
  add_foreign_key "activities", "accounts"
  add_foreign_key "activities", "groups"
  add_foreign_key "batches", "accounts"
  add_foreign_key "collections", "accounts"
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
  add_foreign_key "documents", "contacts"
  add_foreign_key "documents", "users"
  add_foreign_key "events", "accounts"
  add_foreign_key "fields", "accounts"
  add_foreign_key "gifts", "contacts"
  add_foreign_key "gifts", "users"
  add_foreign_key "invitations", "accounts"
  add_foreign_key "invitations", "users"
  add_foreign_key "labels", "accounts"
  add_foreign_key "life_events", "accounts"
  add_foreign_key "life_events", "groups"
  add_foreign_key "links", "contacts"
  add_foreign_key "links", "users"
  add_foreign_key "notes", "contacts"
  add_foreign_key "notes", "users"
  add_foreign_key "pay_charges", "pay_customers", column: "customer_id"
  add_foreign_key "pay_charges", "pay_subscriptions", column: "subscription_id"
  add_foreign_key "pay_payment_methods", "pay_customers", column: "customer_id"
  add_foreign_key "pay_subscriptions", "pay_customers", column: "customer_id"
  add_foreign_key "phone_calls", "contacts"
  add_foreign_key "phone_calls", "users"
  add_foreign_key "preferences", "accounts"
  add_foreign_key "relations", "accounts"
  add_foreign_key "relatives", "accounts"
  add_foreign_key "reminders", "accounts"
  add_foreign_key "reminders", "contacts"
  add_foreign_key "reminders", "users"
  add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_recurring_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "tasks", "contacts"
  add_foreign_key "tasks", "users"
  add_foreign_key "users", "accounts"
  add_foreign_key "users", "users"
end
