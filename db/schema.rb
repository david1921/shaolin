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

ActiveRecord::Schema.define(:version => 20121010025027) do

  create_table "addresses", :force => true do |t|
    t.string   "postcode"
    t.string   "encrypted_address_line_1"
    t.string   "encrypted_address_line_2"
    t.string   "encrypted_address_line_3"
    t.string   "encrypted_address_line_4"
    t.string   "encrypted_address_line_5"
    t.string   "encrypted_post_town"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "info_requests", :force => true do |t|
    t.string   "encrypted_title"
    t.string   "encrypted_first_name"
    t.string   "encrypted_last_name"
    t.string   "encrypted_business_name"
    t.string   "encrypted_email"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "encrypted_additional_details"
    t.string   "encrypted_telephone"
  end

  create_table "key_information_agreements", :force => true do |t|
    t.integer  "owner_id",                                  :null => false
    t.binary   "gzipped_html"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "signature_file_name"
    t.string   "signature_content_type"
    t.integer  "signature_file_size"
    t.datetime "signature_updated_at"
    t.string   "owner_type",                                :null => false
    t.boolean  "electronically_signed",  :default => false
  end

  add_index "key_information_agreements", ["owner_type", "owner_id"], :name => "index_key_information_agreements_on_owner_type_and_owner_id"

  create_table "library_images", :force => true do |t|
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "position"
    t.integer  "lock_version",       :default => 0, :null => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.datetime "deleted_at"
  end

  create_table "merchant_owners", :force => true do |t|
    t.integer  "merchant_id"
    t.string   "encrypted_first_name"
    t.string   "encrypted_last_name"
    t.string   "home_postal_code"
    t.text     "encrypted_home_address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_title"
  end

  add_index "merchant_owners", ["merchant_id"], :name => "index_merchant_owners_on_merchant_id"

  create_table "merchants", :force => true do |t|
    t.string   "status"
    t.string   "uuid"
    t.string   "encrypted_contact_title"
    t.string   "encrypted_contact_first_name"
    t.string   "encrypted_contact_last_name"
    t.string   "contact_position"
    t.string   "encrypted_contact_work_phone_number"
    t.string   "encrypted_contact_work_mobile_number"
    t.string   "encrypted_contact_work_email_address"
    t.boolean  "legal_representative",                                                                       :default => false
    t.boolean  "registered_with_companies_house"
    t.string   "registered_company_number"
    t.string   "registered_company_name"
    t.integer  "registered_company_address_id"
    t.string   "trading_name"
    t.integer  "trading_address_id"
    t.string   "business_name"
    t.integer  "business_address_id"
    t.integer  "billing_address_id"
    t.boolean  "trading_name_is_registered_company_name"
    t.boolean  "trading_address_is_registered_company_address"
    t.boolean  "billing_address_is_registered_company_address"
    t.boolean  "billing_address_is_trading_address"
    t.boolean  "billing_address_is_business_address"
    t.string   "business_website_url"
    t.string   "primary_business_category"
    t.string   "secondary_business_category"
    t.integer  "gross_annual_turnover_cents",                    :limit => 8
    t.boolean  "barclaycard_gpa_merchant"
    t.string   "barclaycard_gpa_number"
    t.string   "encrypted_business_bank_account_name"
    t.string   "encrypted_business_bank_account_number"
    t.string   "encrypted_business_bank_sort_code"
    t.string   "encrypted_business_bank_name"
    t.integer  "business_bank_address_id"
    t.integer  "user_id"
    t.string   "campaign_code"
    t.boolean  "paper_application"
    t.decimal  "negotiated_pre_paid_offer_commission_rate",                   :precision => 10, :scale => 0
    t.datetime "privacy_policy_accepted_at"
    t.boolean  "pre_approved_check_taking_place"
    t.boolean  "manual_credit_check_being_undertaken"
    t.boolean  "existing_barclays_relationship_being_evidenced"
    t.boolean  "record_was_submitted_for_sanctions_approval"
    t.integer  "lock_version",                                                                               :default => 0,     :null => false
    t.datetime "created_at",                                                                                                    :null => false
    t.datetime "updated_at",                                                                                                    :null => false
    t.string   "customer_service_phone_number"
    t.string   "customer_service_email_address"
    t.boolean  "has_business_logo"
    t.string   "business_logo_file_name"
    t.string   "business_logo_content_type"
    t.integer  "business_logo_file_size"
    t.datetime "business_logo_updated_at"
    t.boolean  "existing_barclays_customer",                                                                 :default => false
    t.integer  "exposure_limit"
    t.boolean  "standard_pre_paid_offer_commission_rate"
  end

  add_index "merchants", ["billing_address_id"], :name => "index_merchants_on_billing_address_id"
  add_index "merchants", ["business_address_id"], :name => "index_merchants_on_business_address_id"
  add_index "merchants", ["registered_company_address_id"], :name => "index_merchants_on_registered_company_address_id"
  add_index "merchants", ["trading_address_id"], :name => "index_merchants_on_trading_address_id"

  create_table "offer_targeting_criteria", :force => true do |t|
    t.integer "offer_id"
    t.string  "criterion_type"
    t.string  "value"
  end

  add_index "offer_targeting_criteria", ["offer_id"], :name => "index_offer_targeting_criteria_on_offer_id"

  create_table "offers", :force => true do |t|
    t.string   "type"
    t.string   "primary_category"
    t.string   "secondary_category"
    t.string   "objective"
    t.date     "earliest_start_date"
    t.integer  "duration",                                                                 :default => 30
    t.date     "latest_marketable_date"
    t.string   "business_bank_account_name"
    t.string   "business_bank_account_number"
    t.string   "business_bank_sort_code"
    t.datetime "created_at",                                                                                    :null => false
    t.datetime "updated_at",                                                                                    :null => false
    t.integer  "merchant_id"
    t.string   "title"
    t.integer  "original_price_cents"
    t.integer  "bespoke_price_cents"
    t.integer  "maximum_vouchers"
    t.string   "description"
    t.date     "earliest_redemption"
    t.date     "voucher_expiry"
    t.string   "website_url"
    t.string   "phone"
    t.boolean  "full_redemption"
    t.boolean  "new_customers"
    t.boolean  "no_shows_cancellations_forfeit_voucher"
    t.boolean  "one_per_transaction_per_visit"
    t.boolean  "non_transferrable"
    t.text     "additional_restrictions"
    t.integer  "step",                                                                     :default => 0
    t.integer  "library_image_id"
    t.boolean  "use_merchant_supplied_voucher_code"
    t.boolean  "use_merchant_supplied_image"
    t.boolean  "can_redeem_online"
    t.string   "redemption_website_url"
    t.boolean  "can_redeem_by_phone"
    t.string   "redemption_phone_number"
    t.boolean  "can_redeem_at_outlets",                                                    :default => true,    :null => false
    t.boolean  "allow_social_media_sharing"
    t.boolean  "pricing_attestation",                                                      :default => true
    t.boolean  "capacity_attestation",                                                     :default => true
    t.boolean  "claims_attestation",                                                       :default => true
    t.boolean  "permissions_attestation",                                                  :default => true
    t.boolean  "standard_pre_paid_offer_commission_rate",                                  :default => true
    t.decimal  "negotiated_pre_paid_offer_commission_rate", :precision => 10, :scale => 0
    t.string   "status",                                                                   :default => "draft"
    t.integer  "user_id"
    t.integer  "lock_version",                                                             :default => 0
    t.boolean  "use_own_vouchers",                                                         :default => false
    t.boolean  "choose_own_offer_image",                                                   :default => false
  end

  add_index "offers", ["merchant_id"], :name => "index_offers_on_merchant_id"

  create_table "offers_stores", :force => true do |t|
    t.integer "store_id", :null => false
    t.integer "offer_id", :null => false
  end

  add_index "offers_stores", ["offer_id"], :name => "index_offers_stores_on_offer_id"
  add_index "offers_stores", ["store_id"], :name => "index_offers_stores_on_store_id"

  create_table "post_zones", :id => false, :force => true do |t|
    t.string   "post_code",  :limit => 7, :null => false
    t.string   "post_town",               :null => false
    t.binary   "addresses"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "post_zones", ["post_code"], :name => "index_post_zones_on_post_code", :unique => true

  create_table "stores", :force => true do |t|
    t.integer  "address_id"
    t.integer  "merchant_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "name"
    t.string   "email_address"
    t.string   "phone_number"
    t.string   "opening_hours"
  end

  add_index "stores", ["merchant_id"], :name => "index_stores_on_merchant_id"

  create_table "users", :force => true do |t|
    t.string   "encrypted_email"
    t.string   "encrypted_username"
    t.string   "encrypted_first_name"
    t.string   "encrypted_last_name"
    t.boolean  "active",                              :default => true
    t.boolean  "is_system"
    t.boolean  "is_admin"
    t.boolean  "is_sales"
    t.string   "encrypted_password",   :limit => 128
    t.string   "salt",                 :limit => 128
    t.string   "confirmation_token",   :limit => 128
    t.string   "remember_token",       :limit => 128
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.boolean  "is_merchant"
  end

  add_index "users", ["encrypted_email"], :name => "index_users_on_email"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "versions", :force => true do |t|
    t.integer  "versioned_id"
    t.string   "versioned_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "user_name"
    t.text     "modifications"
    t.integer  "number"
    t.integer  "reverted_from"
    t.string   "tag"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "versions", ["created_at"], :name => "index_versions_on_created_at"
  add_index "versions", ["number"], :name => "index_versions_on_number"
  add_index "versions", ["tag"], :name => "index_versions_on_tag"
  add_index "versions", ["user_id", "user_type"], :name => "index_versions_on_user_id_and_user_type"
  add_index "versions", ["user_name"], :name => "index_versions_on_user_name"
  add_index "versions", ["versioned_id", "versioned_type"], :name => "index_versions_on_versioned_id_and_versioned_type"

end
