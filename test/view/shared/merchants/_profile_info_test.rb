require_relative '../../../test_helper'

module Shared
  module Merchants
    class ProfileInfoPartialTest < ActionView::TestCase

      def setup
        ActionController::Base.prepend_view_path 'app/views/shared/merchant'
      end

      should 'render profile fields' do
        merchant = build(:merchant, customer_service_email_address: 'testy@test.com', customer_service_phone_number: '011234567890', has_business_logo: true)
        render partial: 'profile_info', locals: {merchant: merchant}
        assert_select "span.customer_service_email_address", merchant.customer_service_email_address
        assert_select "span.customer_service_phone_number", merchant.customer_service_phone_number
        assert_select "span.has_business_logo", merchant.has_business_logo
      end
    end
  end
end

