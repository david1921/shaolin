require_relative '../../../test_helper'
require_relative '../lib/search_form_test_helper'

module Sales
  class IndexViewTest < ActionView::TestCase
    include SearchFormTestHelper

    helper do
      def will_paginate(merchants)
        "<div id=\"stubbed_merchant_pagination\"></div>".html_safe
      end

      def page_entries_info(*args)
        "<div id=\"stubbed_page_entries_info\"></div>".html_safe
      end
    end

    def setup
      @merchants = [create(:merchant)]
      ActionController::Base.prepend_view_path 'app/views/sales/merchants'
      render :file => 'index'
    end

    should "have a merchant search form" do
      assert_merchant_search_form
    end

    should "have a 'New Merchant' link" do
      assert_select "a[href=#{new_sales_merchant_path}]", /new merchant/i
    end

    should "have table for merchants" do
      assert_select "div.merchant_table_container"
    end

    should "show page of merchants" do
      assert_select "div[class='merchant_count'][data-merchant-count='#{@merchants.length}']"
    end

    should "show merchant name" do
      assert_select "ul.header li:nth-child(1)"
      merchant = @merchants.first
      assert_select "ul#merchant_row_0 li a", merchant.registered_company_name
      assert_select "ul#merchant_row_0 li a[href=?]", sales_merchant_path(merchant)
    end
  end
end
