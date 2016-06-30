module Sales
  module SearchFormTestHelper
    def assert_merchant_search_form
      assert_select "form#merchant-search[method=get][action=#{sales_merchants_path}]" do
        assert_select "input[name='search[name]']"
        assert_select "input[name='search[post_code]']"
        assert_select 'input[type=submit][value=Search]'
      end
    end
  end
end
