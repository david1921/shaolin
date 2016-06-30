require_relative '../test_helper'

class MerchantSearchTest < ActiveSupport::TestCase
  
  context "when searching for merchants" do

    context 'by name' do
      setup do
        @registered_1 = create_merchant({ registered_company_name: 'Registered Company' })
        @registered_2 = create_merchant({ registered_company_name: 'Registered Inc' })
        create_merchant({ registered_company_name: 'no match' })
      end
      should 'return merchants that match on registered_company_name' do
        @results = Merchant.search nil, { name: 'registered' }

        assert_equal 2, @results.size
        assert_contains @results, @registered_1
        assert_contains @results, @registered_2
      end
    end

    context 'by name' do
      setup do
        @business_1 = create_merchant({ business_name: 'Business Company' })
        @business_2 = create_merchant({ business_name: 'Business Inc' })
        create_merchant({ registered_company_name: 'no match' })
      end
      should 'return merchants that match on business_name' do
        @results = Merchant.search nil, { name: 'business' }

        assert_equal 2, @results.size
        assert_contains @results, @business_1
        assert_contains @results, @business_2
      end
    end

    context 'by name' do
      setup do
        @trading_1 = create_merchant({ trading_name: 'Trading Company' })
        @trading_1 = create_merchant({ trading_name: 'Trading Inc' })
        create_merchant({ registered_company_name: 'no match' })
      end
      should 'return merchants that match on trading_name' do
        @results = Merchant.search nil, { name: 'trading' }

        assert_equal 2, @results.size
        assert_contains @results, @trading_1
        assert_contains @results, @trading_1
      end
    end 

    context 'by postcode' do
      setup do
        @aa99_1 = create_merchant({ business_postcode: 'CC19 9AA' })
        @aa99_2 = create_merchant({ business_postcode: 'CC19 8BB' })
        create_merchant({ registered_company_name: 'no match' })
      end

      should 'return merchants that match on business_address postcode'  do
        @results = Merchant.search nil, { post_code: 'cc19' }

        assert_equal 2, @results.size
        assert_contains @results, @aa99_1
        assert_contains @results, @aa99_2
      end
    end

    context 'by name and postcode' do
      setup do
        @match_1 = create_merchant({ business_name: 'Business Company', business_postcode: 'AA99 9AA' })
        @match_2 = create_merchant({ business_name: 'Business Inc', business_postcode: 'AA99 8BB' })
        create_merchant({ business_name: 'Business Inc', business_postcode: 'BB11 9AA' })
        create_merchant({ business_name: 'no match', business_postcode: 'AA99 8BB' })
      end

      should 'return merchants matching only on both name and postcode' do
        @results = Merchant.search nil, { name: 'business', post_code: 'aa99' }

        assert_equal 2, @results.size
        assert_contains @results, @match_1
        assert_contains @results, @match_2
      end
    end

  end

  def create_merchant(options = {})
    if options.key?(:business_postcode)
      options.merge!({ business_address: build(:address, postcode: options[:business_postcode]) })
      options.delete :business_postcode
    end
    create :registration_gross_annual, options
  end

end