require_relative "../../test_helper"

class Sales::MerchantsControllerTest < ActionController::TestCase

  should "authenticate all actions" do
    [:new, :index].each do |action|
      send(:get, action)
      assert_redirected_to sign_in_url
    end
  end

  context "as an authorized user" do
    setup do
      sign_in_as create(:sales_user)
    end

    context "GET to :new" do
      setup do
        get :new
      end

      should "set a @merchant instance variable and render the new template" do
        assert_response :ok
        assert_instance_of Merchant, assigns(:merchant)
        assert_template 'new'
        assert_select "input[type=submit][name='save']"
        assert_select "input[type=submit][name='submit']"
      end
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

      should 'render the edit template with a submit a submit button' do
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

    context "GET to :index" do
      should "render the index template" do
        get :index
        assert_response :ok
        assert_template 'index'
      end

      context "search" do
        should "show first page of merchants without search query" do
          get :index
          assert_response :success
          assert_template :index
          assert_not_nil assigns(:merchants)
          assert_equal 1, assigns(:merchants).current_page
        end

        should "paginate merchants" do
          get :index, page: 2
          assert_equal 2, assigns(:merchants).current_page
        end

        should "filter merchants" do
          create(:merchant, registered_with_companies_house: true, registered_company_number: '12345678', business_name: false, registered_company_name: 'MyTacoTruck', business_address:  build(:address, postcode: 'AA99 9AA'))
          get :index, search: {name: 'MyTacoTruck', post_code: 'AA99 9AA' }
          assert_response :success
          assert_template :index
          assert_not_nil assigns :merchants
          assert assigns(:merchants).total_entries > 0, "Expected at least 1 merchant to be found"
          assert_equal 1, assigns(:merchants).current_page
        end
      end
    end

  end

  context 'authenticate sales users' do
    should 'GET to :new call the authorize_sales_user and authorize before filters' do
      actions = [[:get, :index], [:get, :new]]
      sign_in_as create(:sales_user)
      @controller.expects(:authorize_sales_user).at_least(actions.size)
      @controller.expects(:authorize).at_least(actions.size)
      actions.each { |method, action| send(method, action) }
    end
  end

  context '#create' do
    setup do
      sign_in_as create :sales_user
    end

    context 'submit and run all validations' do
      should 'create a merchant while validating all fields and redirect to terms and conditions for non paper applications' do
        assert_difference "Merchant.count" do
          post :create, submit: 'submit', merchant: attributes_for(:registration_small).merge(business_address_attributes: attributes_for(:address)).except(:attrs_to_validate)
        end
        assert_redirected_to terms_and_conditions_sales_merchant_url(assigns(:merchant))
        assert_equal 'pending signature', assigns(:merchant).status 
      end

      should "create a merchant while validating all fields, and mark merchant as submitted for paper application" do
        assert_difference "Merchant.count" do
          post :create, submit: 'submit', merchant: attributes_for(:registration_small).merge(business_address_attributes: attributes_for(:address)).except(:attrs_to_validate).merge(paper_application: true)
        end
        assert_redirected_to sales_merchants_url
        assert_equal 'submitted', assigns(:merchant).status 
      end

      should 'fail to create a merchant because of validation failures' do
        post :create, submit: 'submit', merchant: { trading_name: 'beef pork inc' }
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
        assert_redirected_to sales_merchants_path
      end

      should 'create a merchant with only a trading_name' do
        post :create, save: 'save', merchant: { trading_name: 'beef pork inc' }
        assert @controller.send(:save_only?)
        assert_equal 'draft', assigns(:merchant).status
        assert_response :redirect
        assert_redirected_to sales_merchants_path
      end

      should 'run validations on entered data' do
        # contact_work_mobile_number is invalid but otherwise the merchant can be saved
        post :create, save: 'save', merchant: { trading_name: 'beef pork inc', contact_work_mobile_number: '1' }
        assert @controller.send(:save_only?)
        assert_response :ok
        assert_template :new
      end

      should 'fail to create a merchant with no trading_name that is registered with companies house but trading name is not registered name' do
        post :create, save: 'save', merchant: { trading_name: '', registered_with_companies_house: true, trading_name_is_registered_company_name: false }
        assert @controller.send(:save_only?)
        assert_response :ok
        assert_template 'new'
      end
    end
  end

  context '#update' do
    setup do
      sign_in_as create :sales_user
    end
    context 'submit and run all validations' do
      setup do
        @merchant = create :registration_small, status: nil
      end
      should 'update a merchant while validating all fields' do
        assert @merchant.valid?
        put :update, id: @merchant.to_param, submit: 'submit', merchant: { trading_name: 'some new name' }
        assert_redirected_to terms_and_conditions_sales_merchant_url(@merchant) 
        assert_equal 'pending signature', @merchant.reload.status
        assert_equal 'some new name', @merchant.reload.trading_name
      end

      should 'fail to update a merchant because of validation failures' do
        # invalid contact_work_mobile_number in params
        assert @merchant.valid?
        put :update, id: @merchant.to_param, submit: 'submit', merchant: { trading_name: 'some new name', contact_work_mobile_number: '1' }
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
        assert_redirected_to sales_merchants_path
        assert_equal 'draft', @merchant.reload.status
      end

      should 'run validations on entered data' do
        # contact_work_mobile_number is invalid but otherwise the merchant can be saved
        put :update, save: 'save', id: @merchant.to_param, merchant: { trading_name: 'beef pork inc', contact_work_mobile_number: '1' }
        assert @controller.send(:save_only?)
        assert_response :ok
        assert_template :edit
      end

      should 'fail to update a merchant with no trading_name' do
        put :update, save: 'save', id: @merchant.to_param,  merchant: { trading_name: '', registered_with_companies_house: true, trading_name_is_registered_company_name: false }
        assert @controller.send(:save_only?)
        assert_response :ok
        assert_template 'edit'
      end
    end

    context "on 'update' action" do
      should "update merchant with merchant params and redirect to the index" do
        merchant = create(:merchant, trading_name: 'trading name')
        put :update, update: 'Update', id: merchant.to_param, merchant: {trading_name: 'updated trading name'}
        assert_redirected_to sales_merchants_path
        merchant.reload
        assert_equal 'updated trading name', merchant.trading_name
      end
    end
  end

end
