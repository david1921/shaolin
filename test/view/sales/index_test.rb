require_relative '../../test_helper'
require_relative 'lib/search_form_test_helper'

module Sales
  class IndexViewTest < ActionView::TestCase
    include SearchFormTestHelper

    def setup
      ActionController::Base.prepend_view_path 'app/views/sales'
      render :file => 'index'
    end

    should "have a merchant search form" do
      assert_merchant_search_form
    end

    should "have a 'New Merchant' link" do
      assert_select "a[href=#{new_sales_merchant_path}]", /new merchant/i
    end
  end
end