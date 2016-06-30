require_relative '../../test_helper'

class Admin::MerchantValidationsControllerTest < ActionController::TestCase
  setup do
    @user = create :admin_user
    sign_in_as @user
  end

  test '#index' do
    get :index
    assert_response :success
    assert_template :index
    assert_not_nil assigns :merchants
  end

  test '#edit' do
    merchant = create :merchant
    get :edit, id: merchant.id
    assert_response :success
    assert_template :edit
    assert_not_nil assigns :merchant
  end

  context '#update' do
    setup do
      @merchant = create(:merchant, status: 'pending signature')
      @merchant.status = 'submitted'
      @merchant.save!
    end

    context 'approve' do
      setup do
        create(:merchant_owner, merchant: @merchant)
        put :update, id: @merchant.to_param, commit: 'Approve', merchant: { exposure_limit: 1}
      end

      should 'redirect to merchant validations index page' do
        assert_redirected_to admin_merchant_validations_path
      end

      should 'update the merchant status to approve' do
        @merchant.reload
        assert_equal 'approved', @merchant.status
      end
    end

    context 'save' do
      setup do
        put :update, id: @merchant.to_param, commit: 'Save', merchant: {}
      end

      should 'redirect to merchant validations index page' do
        assert_redirected_to admin_merchant_validations_path
      end

      should 'not change the merchant status' do
        @merchant.reload
        assert_equal 'submitted', @merchant.status
      end

    end

    context 'decline' do
      setup do
        put :update, id: @merchant.to_param, commit: 'Decline', merchant: {}
      end
      should 'redirect to merchant validations index page' do
        assert_redirected_to admin_merchant_validations_path
      end

      should 'change the merchant status to declined' do
        @merchant.reload
        assert_equal 'declined', @merchant.status
      end
    end
  end
end
