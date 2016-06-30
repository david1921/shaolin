require_relative '../../../test_helper'

module Shared
  module Merchants
    class ProfileInfoFormPartialTest < ActionView::TestCase
      include SimpleForm::ActionViewExtensions::FormHelper

      helper do
        def merchants_path(merchant = nil)
          ''
        end
      end

      def setup
        ActionController::Base.prepend_view_path 'app/views/shared/merchant'
      end

      should 'render profile fields' do
        @merchant = build(:merchant)

        simple_form_for @merchant do |f|
          render partial: 'profile_info_form', locals: {f: f}
          assert_select "input[name='merchant[customer_service_email_address]']"
          assert_select "input[name='merchant[customer_service_phone_number]']"
          assert_select "input[type='checkbox'][name='merchant[has_business_logo]']"
        end
      end
    end
  end
end
