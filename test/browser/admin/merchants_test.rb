require_relative '../browser_test'
require_relative '../lib/merchants_helper'

module Admin
  class MerchantsTest < ::BrowserTest
    include BrowserTests::MerchantsHelper

    def setup
      @user = create(:admin_user)
    end

    def test_search
      sign_in @user

      without_merchants do
        visit '/admin/merchants'
        screenshot!('admin_merchants_index_no_results')
        assert_no_merchants_found_message
      end

      ensure_at_least_n_merchants(2)
      visit '/admin/merchants'
      screenshot!('admin_merchants_index_some_results')
      assert_a_to_z_filter_menu
      assert_search_result_stats
    end

    def test_new
      require_javascript_driver!
      sign_in @user
      visit '/admin/merchants/new'
      populate_new_merchant
      click_button 'Submit'
      assert_redirected_to_admin_merchants_page
      assert_merchant_created
    end

    def test_edit_and_update
      sign_in @user
      merchant = create(:merchant)
      visit "/admin/merchants/#{merchant.to_param}/edit"
      click_button 'Submit'
      assert_redirected_to_admin_merchants_page

      prepare_merchant_for_update_test(merchant)
      visit "/admin/merchants/#{merchant.to_param}/edit"
      fill_in 'merchant_contact_first_name', with: "updated"
      click_button 'Update'
      visit "/admin/merchants/#{merchant.to_param}/edit"
      assert_merchant_updated
    end

    private

    def assert_a_to_z_filter_menu
      assert has_css?('ul.az_merchant_menu')
    end

    def assert_search_result_stats
      assert page.find('p', text: /Displaying .* merchants/)
    end

    def assert_no_merchants_found_message
      assert has_content?('No merchants found')
    end

    def ensure_at_least_n_merchants(n)
      Merchant.count >= n or (n - Merchant.count).times{create(:merchant)}
    end

    def without_merchants
      begin
        empty_merchant_paginator = Merchant.where("1=0").paginate(page: 1)
        Merchant.stubs(:search).returns(empty_merchant_paginator)
        yield
      ensure
        Merchant.unstub(:search)
      end
    end

    def assert_redirected_to_admin_merchants_page
      assert_equal '/admin/merchants', current_path, "Expected to be on the merchant index page"
      assert page.has_css?('.merchants_table'), "Merchant table was expected. The merchant creation may have failed and re-rendered the merchant form."
    end

    def assert_merchant_created
      assert page.has_css?('.merchant_row'), "Expected a merchant result row"
    end

    def assert_merchant_updated
      assert page.has_css?('input#merchant_contact_first_name[value=updated]'), "Merchant update wasn't persisted"
    end

    def prepare_merchant_for_update_test(merchant)
      merchant.update_column(:status, 'submitted')
    end
  end
end
