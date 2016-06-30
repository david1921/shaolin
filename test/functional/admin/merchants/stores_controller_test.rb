require_relative '../../../test_helper'

class Admin::Merchants::StoresControllerTest < ActionController::TestCase

  setup do
    sign_in_as(create(:admin_user))
    @merchant = create(:merchant)
  end

  context "index" do
    should "get index" do
      get :index, merchant_id: @merchant.to_param

      assert assigns(:stores)
      assert_response :success
      assert_template :index
    end
  end

  context "new" do
    should "get new" do
      Store.any_instance.expects(:build_address)
      
      get :new, merchant_id: @merchant.to_param

      assert assigns(:store)
      assert assigns(:merchant)
      assert_response :success
      assert_template :new
    end
  end

  context "create" do
    should "create a store for the merchant w/ valid parameters" do
      assert_difference 'Store.count' do
        post :create, merchant_id: @merchant.to_param, store: { name: 'my store', address_attributes: attributes_for(:address) }
      end

      assert assigns(:store)
      assert assigns(:merchant)
      assert_response :redirect
      assert_redirected_to admin_merchant_stores_path
    end

    should "not create a store for the merchant w/ invalid parameters" do
      assert_no_difference 'Store.count' do
        post :create, merchant_id: @merchant.to_param, store: {}
      end

      assert assigns(:store)
      assert assigns(:merchant)
      assert_template :new
    end
  end

  context "edit" do
    setup do
      @store = create(:store, merchant: @merchant)
    end

    should "get edit" do
      get :edit, merchant_id: @merchant.to_param, id: @store.to_param

      assert assigns(:store)
      assert assigns(:merchant)
      assert_response :success
      assert_template :edit
    end
  end

  context "update" do
    setup do
      @store = create(:store, merchant: @merchant)
      @store.address.update_attributes(address_line_1: 'This is an old address line 1')
    end

    should "create a store for the merchant w/ valid parameters" do
      put :update, merchant_id: @merchant.to_param, id: @store.id, store: { address_attributes: attributes_for(:address, address_line_1: 'This is some new address line 1') }

      @store.reload
      assert assigns(:store)
      assert assigns(:merchant)
      assert_response :redirect
      assert_equal 'This is some new address line 1', @store.address.address_line_1
      assert_redirected_to admin_merchant_stores_path
    end

  end
end
