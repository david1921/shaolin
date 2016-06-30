module BrowserTests
  module MerchantsHelper
    def populate_new_merchant
      fill_in 'merchant_gross_annual_turnover', with: 1
      select 'Mr', from: 'merchant_contact_title'
      fill_in 'merchant_contact_first_name', with: 'John'
      fill_in 'merchant_contact_last_name', with: 'Smith'
      fill_in 'merchant_contact_position', with: 'Boss'
      check 'merchant_legal_representative'
      check 'merchant_registered_with_companies_house'
      fill_in 'merchant_trading_name', with: 'Acme Company'
      fill_in 'merchant_registered_company_name', with: 'AcmeCo'
      fill_in 'merchant_contact_work_phone_number', with: '01123456789'
      fill_in 'merchant_contact_work_email_address', with: 'test@test.com'
      fill_in 'merchant_business_bank_name', with: 'BigBank'
      fill_in 'merchant_business_bank_sort_code', with: '123'
      fill_in 'merchant_business_bank_account_name', with: 'foo'
      fill_in 'merchant_registered_company_number', with: '12345678'
      select 'Electricals', from: 'merchant_primary_business_category'
      select 'Appliances', from: 'merchant_secondary_business_category'
      check 'merchant_trading_address_is_registered_company_address'
      check 'merchant_billing_address_is_registered_company_address'
      address = build :address
      fill_in 'merchant_registered_company_address_attributes_postcode', with: address.postcode
      fill_in 'merchant_registered_company_address_attributes_address_line_1', with: address.address_line_1
      fill_in 'merchant_registered_company_address_attributes_post_town', with: address.post_town
      check 'merchant_standard_pre_paid_offer_commission_rate'
    end
  end
end