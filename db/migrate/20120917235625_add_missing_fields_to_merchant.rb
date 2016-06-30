class AddMissingFieldsToMerchant < ActiveRecord::Migration
  def change
    change_table :merchants do |t|
      t.boolean :registered_with_companies_house, default: false
      t.boolean :legal_representative, default: false
      t.string  :company_registered_post_code
      t.string  :company_registered_house_name_number
      t.string  :company_registered_address_1
      t.string  :company_registered_address_2
      t.string  :company_registered_address_3
      t.string  :company_registered_address_4
      t.string  :company_registered_address_5
      t.string  :company_reistered_number
      t.string  :barclaycard_merchant_services_gpa_number
      t.string  :company_business_address_address_1
      t.string  :company_business_address_address_2
      t.string  :company_business_address_address_3
      t.string  :company_business_address_address_4
      t.string  :company_business_address_address_5
      t.string  :barclaycard_account_manager_name
      t.string  :barclaycard_account_manager_business_address
      t.string  :barclaycard_account_manager_phone_number
      t.string  :barclaycard_account_manager_email
      t.string  :business_owner_name
      t.string  :business_owner_post_code
      t.string  :business_owner_house_name_number
      t.string  :business_owner_address_1
      t.string  :business_owner_address_2
      t.string  :business_owner_address_3
      t.string  :business_owner_address_4
      t.string  :business_owner_address_5
      t.boolean :pre_approved_check_taking_place, default: false
      t.boolean :manual_credit_check_being_undertaken, default: false
      t.boolean :existing_barclays_relationship_being_evidenced, default: false
      t.boolean :record_was_submitted_for_sanctions_approval, default: false
    end
  end
end
