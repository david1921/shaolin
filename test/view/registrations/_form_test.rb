require_relative '../../test_helper'

module Registrations
  class FormPartialTest < ActionView::TestCase
    setup do
      ActionController::Base.prepend_view_path 'app/views/registrations'
    end

    should "render all of the small form fields" do
      @registration = RegistrationDecorator.new(create(:registration_gross_annual, gross_annual_turnover_cents: 1))

      render partial: 'form'

      assert_select "form.edit_registration" do
        assert_select "input[name='step'][value='registration_small']"
        assert_select "input[name='registration[registered_company_name]']"
        assert_select "input[name='registration[contact_work_phone_number]']"
        assert_select "input[name='registration[contact_work_mobile_number]']"
        assert_select "input[name='registration[contact_work_email_address]']"

        assert_select "select[name='registration[contact_title]']" do
          assert_select "option:first-child[value=]"
          assert_select "option", :minimum => 2
        end

        assert_select "input[name='registration[contact_first_name]']"
        assert_select "input[name='registration[contact_last_name]']"
        assert_select "input[name='registration[contact_position]']"

        #assert_select "input[name='registration[password]']"
        #assert_select "input[name='registration[password_confirmation]']"

        assert_select 'input[type=checkbox]'
        assert_select "a[href=#{privacy_path}]", "Privacy Policy"
        assert_select "a[href=#{terms_path}]", "Standard Terms"
        assert_select "a[href=#{terms_path}]", "Terms and Conditions"

        assert_select "select[name='registration[primary_business_category]']" do
         {:entertainment=>"Entertainment",
          :clothing=>"Clothing and accessories",
          :electrical=>"Electricals",
          :food_and_drink=>"Food and drink",
          :travel=>"Travel",
          :health_and_beauty=>"Health and beauty",
          :home_and_garden=>"Home and garden",
          :office_and_business=>"Office and business",
          :motor=>"Motor",
          :other=>"Other services"}.each do  |key, value| 
            assert_select "option[value=#{key}]", value
          end
        end

        assert_select "select[name='registration[secondary_business_category]']"
        assert_select "input[name='registration[business_website_url]']"

        assert_select "input[name='registration[business_address_attributes][postcode]']"
        assert_select "input[name='registration[business_address_attributes][address_line_1]']"
        assert_select "input[name='registration[business_address_attributes][address_line_1]']"
        assert_select "a", 'Find address'

        assert_select "input[type='submit'][value='Submit Details']"
      end
    end

    should "render all of the large form fields" do
      @registration = RegistrationDecorator.new(create(:registration_gross_annual, gross_annual_turnover_cents: Merchant::LARGE_TURNOVER_THRESHOLD.cents + 1 ))

      render partial: 'form'

      assert_select "form.edit_registration" do
        assert_select "input[name='step'][value='registration_large']"
        assert_select "input[name='registration[trading_name]']"
        assert_select "input[name='registration[contact_work_phone_number]']"
        assert_select "input[name='registration[contact_work_email_address]']"

        assert_select "select[name='registration[contact_title]']" do
          assert_select "option:first-child[value=]"
          assert_select "option", :minimum => 2
        end

        assert_select "input[name='registration[contact_first_name]']"
        assert_select "input[name='registration[contact_last_name]']"
        assert_select "input[name='registration[contact_position]']"

        assert_select "input[type='submit'][value='Submit Details']"
      end
    end
  end
end
