module Sales
  module Merchants
    module SearchTestHelper
      def setup_for_search_test
        @password = 'testing123'
        @search_terms = { name: 'food', post_code: 'AA'}
        @merchants = [
          create(:merchant, registered_with_companies_house: true, business_name: nil, registered_company_name: 'Food One', registered_company_number: 12345678, business_address: build(:address, postcode: 'AA99 9BB')),
          create(:merchant, registered_with_companies_house: true, business_name: nil, registered_company_name: 'Food Two', registered_company_number: 12345678, business_address: build(:address, postcode: 'AA00 0AA')),
          create(:merchant, registered_with_companies_house: true, business_name: nil, registered_company_name: 'Pizza One', registered_company_number: 12345678, business_address: build(:address, postcode: 'CC11 1AA'))
        ]
      end

      def visit_search_merchants_page
        visit '/sales/merchants'
        assert_equal '/sales/merchants', current_path
      end

      def submit_search
        fill_in 'Name', with: @search_terms[:name]
        fill_in 'Post Code', with: @search_terms[:post_code]
        click_on 'Search'
      end

      def assert_unfiltered_results
        @merchants.each do |merchant|
          page.find('a', text: merchant.registered_company_name)
        end
      end

      def assert_filtered_results
        @merchants[0..1].each do |merchant|
          page.find('a', text: merchant.registered_company_name)
        end
      end
    end
  end
end
