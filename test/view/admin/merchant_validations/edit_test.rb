require_relative '../../../test_helper'
module Admin
  module MerchantValidations
    class EditViewTest < ActionView::TestCase

      helper do
        def current_user
          @user ||= FactoryGirl.create(:admin_user)
        end

        def admin_merchant_validation_path
          ''
        end
      end

      setup do
        ActionController::Base.prepend_view_path 'app/views/admin/merchant_validations/'
        @merchant = create(:merchant, status: 'pending signature')
        @merchant.status = 'submitted'
        @merchant.save!
        @merchant_owner = @merchant.merchant_owners.build
      end

      context 'initial processing' do
        setup do
          render template: 'edit'
        end
        should 'have a save button' do
          assert_select "input[value='Save']"
        end

        should 'have an approve button' do
          assert_select "input[value='Approve']"
        end

        should 'hav a decline button' do
          assert_select "input[value='Decline']"
        end
      end

      context 'reprocesing' do
        setup do
          @merchant.reload
          @merchant.decline_validation
          @merchant.save!
          render template: 'edit'
        end

        should 'have a suspend button' do
          assert_select "input[value='Suspend']"
        end

        should 'have an approve button' do
          assert_select "input[value='Approve']"
        end

        should 'hav a decline button' do
          assert_select "input[value='Decline']"
        end
      end
    end
  end
end

