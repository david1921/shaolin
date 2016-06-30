require_relative '../../../../test_helper'

module Admin
  module Merchants
    module MerchantOwners
      class FormPartialTest < ActionView::TestCase

        helper do
          def redirect_to_return_to_or_default_path(arg)
            ''
          end
        end

        setup do
          ActionController::Base.prepend_view_path 'app/views/admin/merchants/merchant_owners/'
          @merchant_owner = create :merchant_owner
          @merchant = @merchant_owner.merchant
        end

        should 'render all the new attributes' do
          with_form_fields do
            render template: 'new'
          end
        end

        should 'render all the edit attributes' do
          with_form_fields do
            render template: 'edit'
          end
        end

        def with_form_fields
          yield
          assert_select "select[name='merchant_owner[title]']"
          assert_select "input[name='merchant_owner[first_name]']"
          assert_select "input[name='merchant_owner[last_name]']"
          assert_select "input[name='merchant_owner[home_postal_code]']"
          assert_select "textarea[name='merchant_owner[home_address]']"
        end
      end
    end
  end
end

