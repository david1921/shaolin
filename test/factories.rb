include ActionDispatch::TestProcess

FactoryGirl.define do

  factory :user do
    sequence :first_name do |n|
      "First#{n}"
    end

    last_name 'Last'
    email { "#{first_name}.#{last_name}.#{SecureRandom.hex(3)}@example.com".downcase }
    username { "#{first_name}#{last_name}".downcase }
    password 'testingtesting'
    is_system false
    is_admin false
    is_sales false
    is_merchant false
    active true

=begin
    This makes :password_confirmation be the same as :password if no value is provided for :password_confirmation.
    This hack is needed because we can find no way in a callback to know whether a value for an attribute was provided.
=end
    password_confirmation 0
    after(:build) do |user, evaluator|
      user.password_confirmation = user.password_confirmation == 0 ? user.password : evaluator.password_confirmation
    end

    factory :password_confirmed_system_user do
      is_system true
      password_confirmation 'testingtesting'
    end

    factory :sales_user do
      is_sales true
    end

    factory :system_user do
      is_system true
    end

    factory :admin_user do
      is_admin true
    end

    factory :merchant_user do
      is_merchant true
      association :merchant, factory: :registration_large_without_user
    end

    factory :merchant_user_large, parent: :merchant_user

    factory :merchant_user_small, parent: :merchant_user do
      association :merchant, factory: :registration_small_without_user
    end

  end

  factory :info_request do
    business_name "XYZ"
    title "Mr"
    first_name "Joe"
    last_name "Smith"
    email "example@example.com"
    telephone  "020 1111 1111"
    additional_details "My additional query details"
  end

  factory :address do
    address_line_1 '123 Some Street'
    address_line_2 'Suite 15'
    post_town 'London'
    postcode 'AA99 9AA'
  end

  factory :library_image do |i|
    photo_file_name 'prevent_attachment_creation.jpg'
    photo_content_type 'image/jpg'
    photo_file_size 0
    photo_updated_at { Time.zone.now }
  end

  factory :registration_gross_annual, class: :merchant do
    gross_annual_turnover_cents 1
    attrs_to_validate RegistrationDecorator::STEP_ATTRS[:gross_annual_turnover]
    standard_pre_paid_offer_commission_rate true
  end

  factory :registration_small_without_user, class: :merchant do
    business_name 'Beef Wellington Industries'
    business_bank_account_name 'Beef-Company'
    business_bank_account_number '1234567'
    contact_work_email_address { "owner.#{SecureRandom.hex(3)}@some-merchant.com" }
    contact_work_mobile_number '07123456789'
    contact_work_phone_number '07123456789'
    trading_name "Acme Entertainment"
    business_website_url 'http://test.com'
    contact_first_name 'John'
    contact_last_name 'Smith'
    contact_position 'boss'
    contact_title 'Mr'
    customer_service_email_address 'foo@example.com'
    customer_service_phone_number '01234567890'
    gross_annual_turnover 1
    primary_business_category Options::Categories::PRIMARY_CATEGORY_KEYS[0]
    secondary_business_category Options::Categories::SECONDARY_CATEGORY_KEYS[Options::Categories::PRIMARY_CATEGORY_KEYS[0]][0]
    business_bank_name 'Cayamn Islands Federal'
    business_bank_sort_code 1234
    association :business_address, factory: :address
    billing_address_is_business_address true
    registered_with_companies_house false
    legal_representative true
    standard_pre_paid_offer_commission_rate true
    attrs_to_validate RegistrationDecorator::STEP_ATTRS[:registration_small]
  end

  factory :registration_small_without_user_registered_company, parent: :registration_small_without_user do
    sequence(:registered_company_name) do |i|
      n = ('a'..'z').to_a[i % 26]
      "#{n}-Barclaycard"
    end
    business_name nil
    registered_with_companies_house true
    registered_company_number '12345678'
  end

  factory :registration_small, parent: :registration_small_without_user do
    association :user, factory: :merchant_user
    attrs_to_validate []
  end

  factory :registration_large_without_user, class: :merchant do
    contact_first_name 'John'
    contact_last_name 'Smith'
    contact_position 'boss'
    contact_title 'Mr'
    legal_representative true
    privacy_policy 1
    business_name 'Acme Co'
    customer_service_email_address 'foo@example.com'
    customer_service_phone_number '01234567890'
    registered_with_companies_house false
    gross_annual_turnover Merchant::LARGE_TURNOVER_THRESHOLD.cents
    trading_name 'Barclaycard'
    business_bank_account_name 'Beef-Company'
    business_bank_name 'Cayamn Islands Federal'
    contact_work_phone_number '07123456789'
    sequence(:contact_work_email_address) {|n| "owner#{n}@some-merchant.com" }
    business_bank_sort_code 1234
    association :business_address, factory: :address
    billing_address_is_business_address true
    standard_pre_paid_offer_commission_rate true
    primary_business_category Options::Categories::PRIMARY_CATEGORY_KEYS.first
    attrs_to_validate RegistrationDecorator::STEP_ATTRS[:registration_large]
  end

  factory :registration_large, parent: :registration_large_without_user do
    association :user, factory: :merchant_user
  end

  factory :merchant, parent: :registration_small_without_user
  factory :merchant_registered, parent: :registration_small_without_user_registered_company

  factory :merchant_owner do
    title 'Mr'
    first_name 'Beef'
    last_name 'Pork'
    association :merchant
  end

  factory :store do
    address
    merchant
    name 'Floyds Barbershop'
    phone_number '07987654321'
    email_address 'floyd@example.com'
    opening_hours '7am - 9pm daily'
  end

  factory :offer do
    association :user, factory: :merchant_user
    merchant

    type 'prepaid'
    objective 'drive_sales'
    primary_category 'entertainment'
    secondary_category 'cinema'
    earliest_start_date { (Time.zone.now. + 2.weeks + 1.day).to_date }
    duration 30
    latest_marketable_date { |o| o.earliest_start_date + o.duration + 1.day }

    title "This is my totally awesome offer!"
    description "This is a my offer description"
    original_price 1
    bespoke_price 0.5
    maximum_vouchers 1000
    voucher_expiry { |o| o.latest_marketable_date }
    earliest_redemption { |o| o.earliest_start_date }
    can_redeem_online false
    can_redeem_by_phone false
    use_merchant_supplied_image true

    standard_pre_paid_offer_commission_rate true
    pricing_attestation true
    claims_attestation true
    permissions_attestation true
    capacity_attestation true
  end

  factory :key_information_agreement do
    html "generated by factory"

    signature_file_name 'prevent_attachment_creation.jpg'
    signature_content_type 'image/jpg'
    signature_file_size 0
    signature_updated_at { Time.zone.now }

    factory :offer_setup_form do
      association :owner, factory: :offer
    end
  end

  factory :prepaid_offer, parent: :offer do
    type 'prepaid'
  end

  factory :free_offer, parent: :offer do
    type 'free'
    original_price nil
    original_price_cents nil
    bespoke_price nil
    bespoke_price_cents nil
  end

  factory :offer_step_1, class: :offer do
    association :user, factory: :merchant_user
    merchant

    type 'prepaid'
    objective 'drive_sales'
    primary_category 'entertainment'
    secondary_category 'cinema'
    earliest_start_date { (Time.zone.now. + 2.weeks).to_date }
    duration 30
    latest_marketable_date { |o| o.earliest_start_date + o.duration + 1.day }

    after(:build) do |offer|
      offer.step = 1
    end
  end

  factory :offer_step_2, parent: :offer_step_1 do
    title "This is my totally awesome offer!"
    description "This is a my offer description"
    original_price 1
    bespoke_price 0.5
    maximum_vouchers 1000
    voucher_expiry { |o| o.latest_marketable_date }
    earliest_redemption { |o| o.earliest_start_date }
    can_redeem_online false
    can_redeem_by_phone false
    library_image_id { create(:library_image).id }

    after(:build) do |offer|
      offer.step = 2
    end
  end

  factory :offer_step_3, parent: :offer_step_2 do
    after(:build) do |offer|
      offer.step = 3
    end
  end

  factory :offer_step_4, parent: :offer_step_3 do
    after(:create) do |offer|
      offer.update_attribute(:step, 4)
    end
  end

  factory :submitted_offer, parent: :offer do
    after(:build) { |offer| offer.send :write_attribute, :status, "submitted" }
  end

  factory :offer_targeting_criterion do
    association(:offer)
  end

  factory :offer_targeting_age_criterion, parent: :offer_targeting_criterion do
    criterion_type OfferTargetingCriterion::TYPES::AGE
    value "18-34"
  end

  factory :offer_targeting_gender_criterion, parent: :offer_targeting_criterion do
    criterion_type OfferTargetingCriterion::TYPES::GENDER
    value "male"
  end

end

