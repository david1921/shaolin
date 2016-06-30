require_relative '../browser_test'
require_relative 'lib/search_test_helper'
require_relative '../lib/merchants_helper'

module Sales
  class MerchantsTest < BrowserTest
    include BrowserTests::MerchantsHelper

    setup do
      @sales_user = create(:sales_user)
    end

    def test_search
      extend Sales::Merchants::SearchTestHelper
      setup_for_search_test
      sign_in @sales_user
      visit_search_merchants_page
      assert_unfiltered_results
      submit_search
      assert_filtered_results
    end

    def test_new
      require_javascript_driver!

      sign_in @sales_user
      visit_new_merchant_page
      fill_in_new_merchant
      submit_new_merchant

      assert_terms_and_conditions_presented

      accept_terms_and_conditions

      # assert_KIF_presented
      # agree_to_KIF

      # assert_signed_KIF_presented
    end

    def test_edit
      sign_in @sales_user
      merchant = create(:merchant)
      visit "/sales/merchants/#{merchant.to_param}/edit"
      submit_update_merchant
      assert_on_sales_merchants_page
    end

  private

    def visit_new_merchant_page
      visit '/sales/merchants/new'
    end

    def submit_new_merchant
      click_button 'Submit'
    end

    def assert_terms_and_conditions_presented
      assert_has_content 'Standard Terms'
       #TODO: Find a better way to verify this?
    end

    def accept_terms_and_conditions
      click_button 'Accept'
    end

    def assert_KIF_presented
      assert_has_content 'Key Information' #TODO: Find a better way to verify this?
    end

    def agree_to_KIF
      click_button 'Sign'
    end

    def assert_signed_KIF_presented
      assert_has_content 'Key Information Form' #TODO: Find a better way to verify this?
      assert_has_element '#signature' #TODO: Find a better way to verify this?
    end

    def fill_in_new_merchant
      populate_new_merchant
      #check 'Privacy Policy'
    end

    def submit_update_merchant
      click_button 'Save as Draft'
    end

    def assert_on_sales_merchants_page
      assert_equal '/sales/merchants', current_path
    end
  end
end
