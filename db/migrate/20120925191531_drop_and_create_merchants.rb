class DropAndCreateMerchants < ActiveRecord::Migration
  def up
    drop_table :merchants

    create_table :merchants do |t|
      t.string  :status
      t.string  :uuid

      t.string  :contact_title
      t.string  :contact_first_name
      t.string  :contact_last_name
      t.string  :contact_position
      t.string  :contact_work_phone_number
      t.string  :contact_work_mobile_number
      t.string  :contact_work_email_address

      t.boolean :legal_representative, default: false

      t.boolean :registered_with_companies_house
      t.string  :registered_company_number

      t.string  :registered_company_name
      t.integer :registered_company_address_id, references: "address"

      t.string  :trading_name
      t.integer :trading_address_id, references: "address"

      t.string  :business_name
      t.integer :business_address_id, references: "address"

      t.integer :billing_address_id, references: "address"

      t.boolean :trading_name_is_registered_company_name
      t.boolean :trading_address_is_registered_company_address
      t.boolean :billing_address_is_registered_company_address
      t.boolean :billing_address_is_trading_address
      t.boolean :billing_address_is_business_address

      t.string  :business_website_url
      t.string  :primary_business_category
      t.string  :secondary_business_category
      t.integer :gross_annual_turnover_cents
      t.boolean :barclaycard_gpa_merchant
      t.string  :barclaycard_gpa_number

      t.string  :business_bank_account_name
      t.string  :business_bank_account_number
      t.string  :business_bank_sort_code
      t.string  :business_bank_name
      t.integer :business_bank_address_id, references: "address"

      t.references :user

      t.string  :campaign_code
      t.boolean :paper_application
      t.decimal :negotiated_pre_paid_offer_commission_rate
      t.timestamp :privacy_policy_accepted_at
      t.boolean :pre_approved_check_taking_place
      t.boolean :manual_credit_check_being_undertaken
      t.boolean :existing_barclays_relationship_being_evidenced
      t.boolean :record_was_submitted_for_sanctions_approval

      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end
    with_options unique: true do
      add_index :merchants, :registered_company_address_id
      add_index :merchants, :trading_address_id
      add_index :merchants, :business_address_id
      add_index :merchants, :billing_address_id
    end
  end

  def down
    ActiveRecord::IrreversibleMigration
  end
end
