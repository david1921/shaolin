require_relative '../../../test_helper'

class Admin::Merchants::MerchantOwnersControllerTest < ActionController::TestCase

  context 'RESTful actions' do
    setup do
      @merchant = create :merchant
      @merchant_owner = create(:merchant_owner, merchant: @merchant)
      @admin_user = FactoryGirl.create(:admin_user)
      sign_in_as(@admin_user)
    end

    context '#edit' do
      should 'render the edit template' do
        get :edit, merchant_id: @merchant.to_param, id: @merchant_owner.to_param
        assert_response :ok
        assert_template 'edit'
      end
    end

    context '#update' do
      should 'update the owner' do
        put :update, merchant_id: @merchant.to_param, id: @merchant_owner.to_param, merchant_owner: {first_name: 'another name'}
        assert_equal 'another name', MerchantOwner.find(@merchant_owner.id).first_name
        assert_response :redirect
        assert_redirected_to edit_admin_merchant_path(@merchant) 
      end

      should 'fail to update and render the edit form' do
        put :update, merchant_id: @merchant.to_param, id: @merchant_owner.to_param, merchant_owner: {first_name: ''} # first_name cannot be blank
        assert_response :ok
        assert_template 'edit'
      end
    end

    context '#new' do
      should 'render the new template' do
        get :new, merchant_id: @merchant.to_param
        assert_response :ok
        assert_template 'new'
      end
    end

    context '#create' do
      should 'create a new owner' do
        valid_attrs = FactoryGirl.attributes_for :merchant_owner
        post :create, merchant_id: @merchant.to_param, merchant_owner: valid_attrs
        assert_response :redirect
        assert_redirected_to edit_admin_merchant_path(@merchant) 
      end

      should 'fail to create a new user and render new' do
        post :create, merchant_id: @merchant.to_param, merchant_owner: {} #invalid attributes
        assert_response :ok
        assert_template 'new'
      end
    end

    context '#destroy' do
      should 'deactivate the user' do
        assert_equal 1, MerchantOwner.count
        delete :destroy, merchant_id: @merchant.to_param, id: @merchant_owner.to_param
        assert_response :redirect
        assert_redirected_to edit_admin_merchant_path(@merchant) 
        assert_equal 0, MerchantOwner.count
      end
    end
  end

  context 'authenticate admin users' do
    should 'authorize_admin_user before filter' do
      @merchant_owner = create :merchant_owner
      actions = { get: :index, get: :edit, get: :new, put: :update, post: :create }
      @controller.expects(:authorize_admin_user).at_least(actions.size)
      @controller.expects(:authorize).at_least(actions.size)
      actions.each do |method, action|
        send(method, action, merchant_id: @merchant_owner.merchant.to_param, id: @merchant_owner.to_param)
      end
    end
  end
end

