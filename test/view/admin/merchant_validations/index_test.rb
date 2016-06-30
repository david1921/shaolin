require_relative '../../../test_helper'
module Admin
  module MerchantValidations
    class IndexViewTest < ActionView::TestCase

      setup do
        ActionController::Base.prepend_view_path 'app/views/admin/merchant_validations/'
        @merchants = [create(:merchant)]
        render template: 'index'
      end

      should 'have merchants table' do
        assert_select 'div.merchants_table'
      end

      should 'have link to validation form' do
        assert_select "a[href='/admin/merchant_validations/#{@merchants[0].to_param}/edit']"
      end
    end
  end
end
