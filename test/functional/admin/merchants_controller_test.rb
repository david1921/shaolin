require_relative '../../test_helper'

class Admin::MerchantsControllerTest < ActionController::TestCase

  setup do
    sign_in_as create :admin_user
  end

  context 'an anonymous user' do
    merchant = FactoryGirl.create :merchant
    actions = [[:get, :index], [:get, :edit], [:get, :new], [:get, :show], [:put, :update], [:post, :create]]
    actions.each do |method, action|
      should "be redirected to the login page on a #{method.to_s.upcase} to #{action}" do
        sign_in_as(nil)
        send(method, action, id: merchant.to_param)
        assert_redirected_to sign_in_url
      end
    end
  end

  context "test data" do

    should "be loaded using FactoryGirl, when params[:test_data] is '1'" do
      FactoryGirl.expects(:attributes_for).returns(trading_name: "Test Business Name")
      get :new, test_data: "1"
      assert_equal "Test Business Name", assigns(:merchant).trading_name
    end

  end

  test '#index' do
    get :index
    assert_response :success
    assert_template :index
    assert_not_nil assigns :merchants
  end

  test '#index for search' do
    get :index, merchant: {registered_company_name: 'MyTacoTruck', address_postcode: 'AA99 9AA' }
    assert_response :success
    assert_template :index
    assert_not_nil assigns :merchants
  end

  test '#index search for validation status' do
    merchant = FactoryGirl.create(:merchant, status: 'draft')
    get :index, search: {status: "#{merchant.status}"}
    assert_response :success
    assert_template :index
    assert_select "li[class='status column']", {:text => merchant.status.to_s.capitalize }
    assert_not_nil assigns :merchants
  end

  should 'paginate merchants' do
    get :index, page: 2
    assert_equal 2, assigns(:merchants).current_page
  end

  test '#new' do
    get :new
    assert_response :success
    assert_template :new
    assert_not_nil assigns :merchant
    assert_select "input[type=submit][name='save']"
    assert_select "input[type=submit][name='submit']"
  end

  test '#show' do
    merchant = FactoryGirl.create(:merchant)
    get :show, id: merchant.id
    assert_response :success
    assert_template :show
    assert_not_nil assigns :merchant
  end

  context '#edit' do
    should 'render the edit template with save and submit buttons' do
      merchant = FactoryGirl.create(:merchant)
      get :edit, id: merchant.id
      assert_response :success
      assert_template :edit
      assert_not_nil assigns :merchant
      assert_select "input[type=submit][name='save']"
      assert_select "input[type=submit][name='submit']"
      assert_select "input[type=submit][name='update']", 0
    end

    should 'render the edit template with a submit button' do
      merchant = FactoryGirl.create(:merchant, :status => 'pending signature')
      get :edit, id: merchant.id
      assert_response :success
      assert_template :edit
      assert_not_nil assigns :merchant
      assert_select "input[type=submit][name='save']", 0
      assert_select "input[type=submit][name='submit']"
      assert_select "input[type=submit][name='update']", 0
    end

    should 'render the edit template with an update submit button' do
      merchant = FactoryGirl.create(:merchant, :status => 'pending signature')
      merchant.update_attributes! status: 'submitted'
      get :edit, id: merchant.id
      assert_response :success
      assert_template :edit
      assert_not_nil assigns :merchant
      assert_select "input[type=submit][name='save']", 0
      assert_select "input[type=submit][name='submit']", 0
      assert_select "input[type=submit][name='update']"
    end
  end

  context '#create' do
    context 'submit and run all validations' do
      should 'create a merchant while validating all fields and should set state to pending signature if not a paper application' do
        assert_difference "Merchant.count" do
          post :create, submit: 'submit', merchant: attributes_for(:registration_small).merge(business_address_attributes: attributes_for(:address)).except(:attrs_to_validate).merge(paper_application: false)
        end
        assert_redirected_to admin_merchants_path
        assert_equal 'pending signature', assigns(:merchant).status 
      end

      should 'create a merchant while validating all fields and should set state to submitted for a paper application' do
        assert_difference "Merchant.count" do
          post :create, submit: 'submit', merchant: attributes_for(:registration_small).merge(business_address_attributes: attributes_for(:address)).except(:attrs_to_validate).merge(paper_application: true)
        end
        assert_redirected_to admin_merchants_path
        assert_equal 'submitted', assigns(:merchant).status 
      end

      should 'render the new template  when there are validation errors' do
        post :create, submit: 'submit', merchant: { trading_name: 'beef pork inc' }
        assert assigns(:merchant).errors.any?
        assert_response :ok
        assert_template 'new'
      end
    end

    context 'save with limited validations' do
      should 'create a merchant with all attributes' do
        assert_difference "Merchant.count" do
          post :create, save: 'save', merchant: attributes_for(:registration_small).except(:attrs_to_validate)
        end
        assert_equal 'draft', assigns(:merchant).status
        assert @controller.send(:save_only?)
        assert_response :redirect
        assert_redirected_to admin_merchants_path
      end

      should 'create a merchant with only a trading_name' do
        post :create, save: 'save', merchant: { trading_name: 'beef pork inc' }
        assert @controller.send(:save_only?)
        assert_response :redirect
        assert_redirected_to admin_merchants_path
      end

      should 'run validations on entered data' do
        # contact_work_mobile_number is invalid but otherwise the merchant can be saved
        post :create, save: 'save', merchant: { trading_name: 'beef pork inc', contact_work_mobile_number: '1' }
        assert @controller.send(:save_only?)
        assert_response :ok
        assert_template :new
      end

      should 'fail to create a merchant with no trading_name if they are registered with companies house but trading name is not registered company name' do
        post :create, save: 'save', merchant: { trading_name: '', registered_with_companies_house: true, trading_name_is_registered_company_name: false }
        assert @controller.send(:save_only?)
        assert_response :ok
        assert_template 'new'
      end
    end
  end

  context '#update' do
    context 'submit and run all validations' do
      setup do
        @merchant = create :registration_small, status: nil
      end
      should 'update a merchant while validating all fields' do
        assert @merchant.valid?
        put :update, submit: 'submit', id: @merchant.to_param, merchant: { trading_name: 'some new name' }
        assert_equal 'pending signature', assigns(:merchant).status
        assert_redirected_to admin_merchants_path
        assert_equal 'some new name', @merchant.reload.trading_name
      end

      should 'render the edit template with errors' do
        # invalid contact_work_mobile_number in params
        assert @merchant.valid?
        put :update, submit: 'submit', id: @merchant.to_param, merchant: { trading_name: 'some new name', contact_work_mobile_number: '1' }
        assert assigns(:merchant).errors[:contact_work_mobile_number].any?
        assert_response :ok
        assert_template :edit
      end
    end

    context 'save with limited validatoins' do
      setup do
        @merchant_using_seletive_validation  = create :registration_gross_annual
        @merchant = Merchant.find(@merchant_using_seletive_validation.id)
      end
      should 'update a merchant with all attributes' do
        assert !@merchant.valid?
        put :update, save: 'save', id: @merchant.to_param, merchant: attributes_for(:registration_small).except(:attrs_to_validate)
        assert @controller.send(:save_only?)
        assert_response :redirect
        assert_redirected_to admin_merchants_path
      end

      should 'run validations on entered data' do
        # contact_work_mobile_number is invalid but otherwise the merchant can be saved
        put :update, save: 'save', id: @merchant.to_param, merchant: { trading_name: 'beef pork inc', contact_work_mobile_number: '1' }
        assert @controller.send(:save_only?)
        assert_response :ok
        assert_template :edit
      end

      should 'fail to update a merchant with no trading_name that is registered with companies house but trading name is not registered name' do
        put :update, save: 'save', id: @merchant.to_param, merchant: { trading_name: '', registered_with_companies_house: true, trading_name_is_registered_company_name: false }
        assert @controller.send(:save_only?)
        assert_response :ok
        assert_template 'edit'
      end
    end

  end

  context '#save_only?' do
    should 'be true' do
      @controller.stubs(:params).returns( save: 'save' )
      assert @controller.send(:save_only?)
    end
    should 'be false' do
      @controller.stubs(:params).returns( save_only: 'false' )
      assert !@controller.send(:save_only?)
    end
  end

end
