# Purpose: Development/TEST Seed Data
# Usage:   rake db:seed - Loads the seed data from db/seeds.rb,
#                                                  db/seeds/*.seeds.rb,
#                                                  db/seeds/development/*.seeds.rb
# Env:  RAILS_ENV is not set or is 'development'
# Docs: https://github.com/james2m/seedbank#readme or run rake --tasks


require 'factory_girl'
include FactoryGirl::Syntax::Methods

user = User.find_by_username('owner@some-merchant.com') ||
    FactoryGirl.create(:merchant_user,
           email: 'owner@some-merchant.com',
           username: 'owner@some-merchant.com',
           first_name: 'John',
           last_name: 'Smith',
           active: true,
           is_merchant: true,
           password: '123MySecret',
           password_confirmation: '123MySecret'
    )

merchant = Merchant.find_by_registered_company_name('Barclaycard') ||
    FactoryGirl.create(:merchant_registered,
           user: user,
           business_bank_account_name: 'Beef-Company',
           business_bank_account_number: '1234567',
           business_bank_sort_code: 'AB',
           contact_work_email_address: 'owner@some-merchant.com',
           contact_work_mobile_number: '07123456789',
           contact_work_phone_number: '07123456789',
           registered_with_companies_house: true,
           registered_company_name: 'Barclaycard',
           business_website_url: 'http://test.com',
           contact_first_name: 'John',
           contact_last_name: 'Smith',
           contact_position: 'boss',
           contact_title: 'Mr',
           gross_annual_turnover: 1,
           primary_business_category: 'entertainment',
           trading_name_is_registered_company_name: false,
           trading_address_is_registered_company_address: true,
           status: 'draft'
    )

# seed for Merchant versions testing
merchant.update_attribute(:contact_first_name, 'Sally')

User.find_by_username('system') ||
    FactoryGirl.create(:user,
           email: 'system@some-merchant.com',
           username: 'system',
           first_name: 'Mike',
           last_name: 'Doe',
           active: true,
           is_system: true,
           is_admin: true,
           is_sales: true,
           password: 'testing123',
           password_confirmation: 'testing123'
    )

User.find_by_username('salesagent') ||
    FactoryGirl.create(:sales_user,
           email: 'salesagent@example.com',
           username: 'salesagent',
           first_name: 'Jamie',
           last_name: 'Smithee',
           password: 'testing123'
    )

merchants = FactoryGirl.create_list(:merchant, 100)

merchants[0..10].each do |merchant|
  FactoryGirl.create :offer, { merchant: merchant } 
end

records = [1, 3, 5, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 39, 40, 41, 42, 44, 46, 48, 49, 50, 51, 53, 55, "44A"].collect do |building_number|
  {
      :building_number => building_number,
      :thoroughfares => ["HALL DRIVE"],
      :localities => ["HARDWICK"]
  }
end

PostZone.find_or_create_by_post_code("CB237QN", :post_town => "CAMBRIDGE", :records => records)
