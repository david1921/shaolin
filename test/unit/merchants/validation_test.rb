require_relative '../../test_helper'
require_relative '../../validation_test_helper'

class Merchant::ValidationTest < ActiveSupport::TestCase
  include ::ValidationTestHelper

  setup do
    @merchant = Merchant.new
    set_target @merchant
  end

  context 'canonical name' do
    setup do
      @merchant.registered_company_name = "RCN Co"
      @merchant.business_name = "Business Co"
    end
    should 'be invalid with both registered_company_name and business_name' do
      assert_attribute_value_invalid :registered_company_name, 'rcn value'
      assert_attribute_value_invalid :business_name, 'b value'
    end
  end

  context 'when registered_with_companies_house' do
    context 'is true' do
      setup do
        @merchant.registered_with_companies_house = true
      end
      context 'registered_company_name' do
        should 'be required' do
          assert_attribute_value_invalid :registered_company_name, nil
        end
        should 'allow allows only alphanumeric, spaces, command, dashes and apostrophes' do
          assert_attribute_value_valid :registered_company_name, "X,'x--  ',"
          assert_attribute_value_invalid :registered_company_name, "!"
        end
        should 'accept only between 2 and 80 characters' do
          assert_length_range :registered_company_name, 2, 80
        end
      end
      context 'registered_company_address' do
        should 'be required' do
          assert_attribute_value_invalid :registered_company_address, nil
        end
      end
      context 'business_name' do
        should 'be optional' do
          assert_attribute_value_valid :business_name, nil
        end
      end
      context 'business_address' do
        should 'be optional' do
          assert_attribute_value_valid :business_address, nil
        end
      end
      context 'and trading_name_is_registered_company_name?' do
        context 'is true, trading name' do
          setup do 
            @merchant.trading_name_is_registered_company_name = true 
          end
          should 'be optional' do
            assert_attribute_value_valid :trading_name, nil
          end
        end
        context 'is false, trading name' do
          setup do 
            @merchant.trading_name_is_registered_company_name = false 
          end
          should 'be required' do
            assert_attribute_value_invalid :trading_name, nil
          end
        end
      end
      context 'and trading_address_is_registered_company_address?' do
        context 'is true, trading_address' do
          setup do
            @merchant.trading_address_is_registered_company_address = true
          end
          should 'be optional' do
            assert_attribute_value_valid :trading_address, nil
          end
        end
        context 'is true, trading_address' do
          setup do
            @merchant.trading_address_is_registered_company_address = false
          end        
          should 'be required' do
            assert_attribute_value_invalid :trading_address, nil
          end
        end
      end
      context 'and billing_address_is_registered_company_address?' do
        context 'is true, billing_address' do
          setup do
            @merchant.billing_address_is_registered_company_address = true
          end
          should 'be optional' do
            assert_attribute_value_valid :billing_address, nil
          end
        end
        context 'is false, billing_address' do
          setup do
            @merchant.billing_address_is_registered_company_address = false
          end
          should 'be required' do
            assert_attribute_value_invalid :billing_address, nil
          end
        end
      end
      context 'and billing_address_is_trading_address?' do
        context 'is true, billing_address' do
          setup do
            @merchant.billing_address_is_registered_company_address = true
          end
          should 'be optional' do
            assert_attribute_value_valid :billing_address, nil
          end
        end
        context 'is false, billing_address' do
          setup do
            @merchant.billing_address_is_registered_company_address = false
          end
          should 'be required' do
            assert_attribute_value_invalid :billing_address, nil
          end
        end
      end
    end

    context 'is false' do
      setup do
        @merchant.registered_with_companies_house = false
      end
      context 'registered_company_name' do
        should 'be optional' do
          assert_attribute_value_valid :registered_company_name, nil
        end
      end
      context 'registered_company_address' do
        should 'be optional' do
          assert_attribute_value_valid :registered_company_address, nil
        end
      end
      context 'business_name' do
        should 'be required' do
          assert_attribute_value_invalid :business_name, nil
        end
      end
      context 'business_address' do
        should 'be required' do
          assert_attribute_value_invalid :business_address, nil
        end
      end
      context 'trading name' do
        should 'be optional' do
          assert_attribute_value_valid :trading_name, nil
        end
      end
      context 'trading_address' do
        should 'be optional' do
          assert_attribute_value_valid :trading_address, nil
        end
      end
      context 'and billing_address_is_business_address?' do
        context 'is true, billing_address' do
          setup do
            @merchant.billing_address_is_business_address = true
          end
          should 'be optional' do
            assert_attribute_value_valid :billing_address, nil
          end
        end
        context 'is false, billing_address' do
          setup do
            @merchant.billing_address_is_business_address = false
          end
          should 'be required' do
            assert_attribute_value_invalid :billing_address, nil
          end
        end
      end
    end
  end

  context 'contact_first_name' do
    should 'allow only a valid alpha first name' do
      verify_attribute_validated_with_validator(Merchant, :contact_first_name, AlphaNameValidator)
    end
    should 'be required' do
      assert_attribute_value_invalid :contact_first_name, nil
    end
    should 'accept only between 2 and 40 characters' do
      assert_length_range :contact_first_name, 2, 40
    end
  end

  context 'contact_last_name' do
    should 'allow only a valid alpha first name' do
      verify_attribute_validated_with_validator(Merchant, :contact_last_name, AlphaNameValidator)
    end
    should 'be required' do
      assert_attribute_value_invalid :contact_last_name, nil
    end
    should 'accept only between 2 and 40 characters' do
      assert_length_range :contact_last_name, 2, 40
    end
  end

  context 'business_bank_account_number' do
    should 'accept only numbers' do
      assert_attribute_value_invalid :business_bank_account_number, '1234567A'
      assert_attribute_value_invalid :business_bank_account_number, '123-4567'
    end
    should 'accept between 7 and 8 digits for a non barclays number' do
      assert_length_range :business_bank_account_number, 7, 8, '1'
    end
    should 'be 8 digits if a barclays number' do
      assert_attribute_value_invalid :business_bank_account_number,  '2034567'
    end
    should 'be optional' do
      assert_attribute_value_valid :business_bank_account_number, nil
    end
  end

  context 'business_bank_name' do
    should 'be optional' do
      assert_attribute_value_valid :business_bank_name, nil
    end
    should 'accept alphanumeric, spaces, commas, dashes and apostrophes'  do
      assert_attribute_value_valid :business_bank_name, "Foo- b,a'r- baz 1, 2"
    end
    should 'accept between 2 and 40 digits' do
      assert_length_range :business_bank_name, 2, 40
    end
  end

  context 'primary_business_category' do
    should 'be required' do
      assert_attribute_value_valid :primary_business_category, Merchant::PRIMARY_CATEGORY_KEYS.first
    end
    should 'accept only one of the values for primary category keys' do
      Merchant::PRIMARY_CATEGORY_KEYS.each { |key| assert_attribute_value_valid :primary_business_category, key }
      assert_attribute_value_invalid :primary_business_category, 'foobar'
    end
  end

  context "contact_work_phone_number" do
    should "be required if contact_work_mobile_number is not present" do
      @merchant.contact_work_mobile_number = nil
      assert_attribute_value_invalid :contact_work_phone_number, nil
    end
    should "be optional if contact_work_mobile_number is present" do
      @merchant.contact_work_mobile_number = "07123456789"
      assert_attribute_value_valid :contact_work_phone_number, nil
    end
    should 'allow only a valid landline number' do
      verify_attribute_validated_with_validator(Merchant, :contact_work_phone_number, LandlinePhoneValidator)
    end
  end

  context "contact_work_mobile_number" do
    should "be required if contact_work_phone_number is not present" do
      @merchant.contact_work_phone_number = nil
      assert_attribute_value_invalid :contact_work_mobile_number, nil
    end
    should "be optional if contact_work_mobile_number is present" do
      @merchant.contact_work_phone_number = "07123456789"
      assert_attribute_value_valid :contact_work_mobile_number, nil
    end
    should 'allow only a valid mobile number' do
      verify_attribute_validated_with_validator(Merchant, :contact_work_mobile_number, MobilePhoneValidator)
    end
  end

  context "business_website_url" do
    should 'be optional' do
      assert_attribute_value_valid :business_website_url, nil
    end
    should "validate format" do
      invalid_urls   = %w(htp://something.com some`thing)
      valid_urls = %w(http://something.com https://something.co)

      merchant = Merchant.new

      invalid_urls.each do |site|
        merchant.business_website_url = site
        merchant.valid?
        assert_present merchant.errors[:business_website_url]
      end

      valid_urls.each do |site|
        merchant.business_website_url = site
        merchant.valid?
        assert_blank merchant.errors[:business_website_url]
      end
    end
    should 'accept between 5 and 50 characters' do
      verify_attribute_validated_with_validator(Merchant, :business_website_url, ActiveModel::Validations::LengthValidator, { minimum: 5, maximum: 50, allow_blank: true })
    end
    should 'accept only a valid url' do
      verify_attribute_validated_with_validator(Merchant, :business_website_url, UrlValidator, { allow_blank: true })
    end
  end

  context "privacy_policy" do
    should "NOT allow unaccepted" do
      assert_attribute_value_invalid :privacy_policy, '2'
    end
    should "allow accepted" do
      assert_attribute_value_valid :privacy_policy, '1'
    end
  end

  context "business_bank_account_name" do
    should "be optional" do
      assert_attribute_value_valid :business_bank_account_name, nil
    end

    should "accept between 2 and 30 characters" do
      assert_length_range :business_bank_account_name, 2, 30
    end

    should "accept alphanumerics, dashes, commas, and apostrophes" do
      assert_attribute_value_valid :business_bank_account_name, "A1 ,'-"
    end

    should "NOT accept non alphanumeric characters" do
      assert_attribute_value_invalid :business_bank_account_name, 'aa!'
    end

  end

  context "business_bank_sort_code" do
    should 'accept only numbers' do
      assert_attribute_value_valid :business_bank_sort_code, '12'
      assert_attribute_value_invalid :business_bank_sort_code, 'Aa'
      assert_attribute_value_invalid :business_bank_sort_code, '!'
    end

    should "be optional" do
      assert_attribute_value_valid :business_bank_sort_code, nil
    end

    should "accept between 2 and 6 characters" do
      @merchant.registered_with_companies_house = true
      assert_length_range :business_bank_sort_code, 2, 6, '1'
    end
  end

  context "contact_work_email_address" do
    should "be required" do
      assert_attribute_value_invalid :contact_work_email_address, nil
    end

    should "NOT accept an invalid email" do
      ['invalid address', 'invalid@domain', 'invalid@domain.', '@domain.com'].each do |invalid_email|
        assert_attribute_value_invalid :contact_work_email_address, invalid_email
      end
    end

    should "accept a valid email" do
      ["valid_address@domain.com", "valid_address+2@domain.com", "valid.address@domain.co.uk"].each do |valid_email|
        assert_attribute_value_valid :contact_work_email_address, valid_email
      end
    end
    
    should "be unique" do
      merchant_1 = create :merchant, contact_work_email_address: "m1@example.com"
      merchant_2 = create :merchant, contact_work_email_address: "m2@example.com"

      merchant_1.contact_work_email_address = "m2@example.com"
      assert merchant_1.invalid?, "merchant with duplicate contact_work_email_address should be invalid"
      assert merchant_1.errors[:contact_work_email_address], "merchant with duplicate contact_work_email_address should have errors on contact_work_email_address"
      assert_equal ["has already been taken"], merchant_1.errors[:contact_work_email_address]

      merchant_1.contact_work_email_address = "m1@example.com"
      assert merchant_1.valid?, "merchant with unique email address should be valid"

      new_merchant = build :merchant, contact_work_email_address: "m1@example.com"
      assert new_merchant.invalid?, "new merchant record with duplicate email address should be invalid"
      assert new_merchant.errors[:contact_work_email_address], "new merchant with duplicate contact_work_email_address should have errors on contact_work_email_address"
    end
  end

  context "contact_position" do

    should "accept between 2 and 20 characters" do
      assert_length_range :contact_position, 2, 20
    end

  end

  context "contact_title" do
    should "be required" do
      assert_attribute_value_invalid :contact_title, nil
    end
    should "NOT accept an non bespoke contact title" do
      assert_attribute_value_invalid :contact_title, 'invalid title'
    end
    should "accept a bespoke contact title" do
      assert_attribute_value_valid :contact_title, 'Lord'
    end
  end

  context "secondary_business_category" do
    should "be optional" do
      @merchant.primary_business_category = nil
      assert_attribute_value_valid :secondary_business_category, nil
      assert_attribute_value_valid :secondary_business_category, ''
    end
    should "be be blank if primary_business_category is not selected" do
      @merchant.primary_business_category = nil
      assert_attribute_value_invalid :secondary_business_category, "mobile"
    end
    should "accept a secondary category for the specified primary_business_category" do
      @merchant.primary_business_category = "electrical"
      assert_attribute_value_valid :secondary_business_category, "mobile"
    end
    should "NOT accept a secondary category for some different primary_business_category" do
      @merchant.primary_business_category = "electrical"
      assert_attribute_value_invalid :secondary_business_category, "bars_and_pubs"
    end
  end

  context 'trading_name' do
    setup do
      @merchant.registered_with_companies_house = true
      @merchant.trading_name = 'Acme Trading Co'
    end
    should 'accept only between 2 and 80 characters' do
      assert_length_range :trading_name, 2, 80
    end
    should 'accept alphanumeric, spaces, commas, dashes and apostrophes'  do
      assert_attribute_value_valid :trading_name, "Foo- b,a'r- baz 1, 2"
    end
    should 'NOT accept other characters' do
      assert_attribute_value_invalid :trading_name, 'Foo * bar'
    end
  end

  context 'gross_annual_turnover' do
    should 'accept numeric' do
      assert_attribute_value_valid :gross_annual_turnover, 12
    end
    should 'NOT accept non numeric' do
      assert_attribute_value_invalid :gross_annual_turnover, 'x'
    end
    should 'NOT accept zero' do
      assert_attribute_value_invalid :gross_annual_turnover, 0
    end
  end

  context 'registered_with_companies_house' do
    should 'be true or false' do
      assert_attribute_value_invalid :registered_with_companies_house, nil
      assert_attribute_value_valid :registered_with_companies_house, true
      assert_attribute_value_valid :registered_with_companies_house, false
    end
  end

  context 'registered_company_number' do
    should 'be only 8 characters in length' do
      @merchant.registered_with_companies_house = true
      assert_length_is :registered_company_number, 8, "1"
    end

    should "accept letters only as first 2 characters" do
      @merchant.registered_with_companies_house = true
      assert_attribute_value_invalid :registered_company_number, "abc12345"
      assert_attribute_value_invalid :registered_company_number, "123456ab"
      assert_attribute_value_valid :registered_company_number, "ab123456"
    end

    should "accept all numbers" do
      @merchant.registered_with_companies_house = true
      assert_attribute_value_invalid :registered_company_number, "abcdabcd"
      assert_attribute_value_invalid :registered_company_number, "ab$1234"
      assert_attribute_value_valid :registered_company_number, "12345678"
    end
  end

  context 'customer service details' do
    context 'when merchant has no offers' do

      should_validate_attribute_with_validator(Merchant, :customer_service_email_address, EmailValidator, {allow_blank: true})
      should_validate_attribute_with_validator(Merchant, :customer_service_phone_number, LandlinePhoneValidator, {allow_blank: true})

      should "not require customer service details" do
        assert_attribute_value_valid :customer_service_email_address, nil
        assert_attribute_value_valid :customer_service_phone_number, nil
      end

      should "NOT accept an invalid email" do
        ['invalid address', 'invalid@domain', 'invalid@domain.', '@domain.com'].each do |invalid_email|
          assert_attribute_value_invalid :customer_service_email_address, invalid_email
        end
      end

      should "accept a valid email" do
        ["valid_address@domain.com", "valid_address+2@domain.com", "valid.address@domain.co.uk"].each do |valid_email|
          assert_attribute_value_valid :customer_service_email_address, valid_email
        end
      end
    end

    context 'when merchant has offers' do
      should 'require customer service details' do
        merchant = create(
          :registration_small, 
          customer_service_email_address: nil, 
          customer_service_phone_number: nil
        )
        set_target merchant

        create :offer, merchant: merchant
        
        refute merchant.valid?, "should not be valid without customer service details"
        assert_attribute_value_invalid :customer_service_email_address, nil
        assert_attribute_value_invalid :customer_service_phone_number, nil
      end
    end
  end


  context 'existing_barclays_customer' do
    should 'be true or false' do
      assert_attribute_value_invalid :existing_barclays_customer, nil
      assert_attribute_value_valid :existing_barclays_customer, true
      assert_attribute_value_valid :existing_barclays_customer, false
    end
  end

    context 'legal_representative' do
    should 'be true' do
      assert_attribute_value_invalid :legal_representative, nil
      assert_attribute_value_invalid :legal_representative, false
      assert_attribute_value_valid :legal_representative, true
    end
  end
end

