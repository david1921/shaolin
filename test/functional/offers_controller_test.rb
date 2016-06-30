require_relative '../test_helper'

class OffersControllerTest < ActionController::TestCase

  def setup
    sign_in_as(merchant_user = create(:merchant_user))
    @merchant = merchant_user.merchant
  end

  test "require merchant user on all pages" do
    OffersController.expects(:before_filter).with(:authorize)
    OffersController.expects(:before_filter).with(:set_merchant)
    OffersController.expects(:before_filter).with(:set_offer, except: [:new, :create])
    OffersController.expects(:before_filter).with(:set_steps, except: [:new, :create])
    quietly { load "#{Rails.root}/app/controllers/offers_controller.rb" }
  end

  test "403 when accessed with non-merchant user" do
    sign_in_as(create(:system_user))
    get :new
    assert_response :forbidden
  end

  test '#new' do
    get :new
    assert_response :success
    assert_template :new
    assert_not_nil  assigns(:offer)
    assert_template partial: 'offers/_step_1'
    assert_select "button.save_progress", false
  end

  test '#create (step 1, valid)' do
    assert_difference 'Offer.count' do
      post :create, offer: attributes_for(:offer_step_1)
    end
    offer = Offer.last
    assert offer.merchant
    assert_equal 1, offer.step
    assert_redirected_to edit_offer_path(offer)
  end

  test '#create invalid' do
    post :create, offer: {}
    assert_response :ok
    assert_template :new
  end

  test '#save_progress w/ format.js (success)' do
    offer = create(:offer_step_1, merchant: @merchant, title: "This is the offer's title")
    xhr :put, :save_progress, offer: { title: "Hello" }, id: offer.to_param, format: :js
    assert_response 200
    assert_template nil

    offer.reload
    assert assigns(:offer)
    assert_equal "Hello", offer.title, "The title should be saved"
    assert_equal 1, offer.step, "The step should not change"
  end

  test '#save_progress w/ format.js (fail)' do
    offer = create(:offer_step_1, merchant: @merchant, title: "This is the offer's title")
    Offer.any_instance.stubs(:update_step_and_attributes).returns(false)
    xhr :put, :save_progress, offer: { title: "Hello" }, id: offer.to_param, format: :js
    assert_response 500
    assert_template nil

    offer.reload
    assert assigns(:offer)
    assert_equal "This is the offer's title", offer.title, "The title should not have been saved"
    assert_equal 1, offer.step, "The step should not change"
  end

  test 'edit' do
    offer = create(:offer_step_1, merchant: @merchant)
    get :edit, id: offer.to_param, view_step: 1

    assert assigns(:offer)
    assert_response :success
    assert_template :edit
    assert_select "input[name='view_step'][value='1']"
  end

  test 'edit after completing step 1' do
    offer = create(:offer_step_1, merchant: @merchant)
    get :edit, id: offer.to_param

    assert assigns(:offer)
    assert_response :success
    assert_template :edit
    assert_template partial: 'offers/_step_2'
    assert_select "button.save_progress"
  end

  test 'edit after completing step2' do
    offer = create(:offer_step_2, merchant: @merchant)
    assert_equal 2, offer.step
    get :edit, id: offer.to_param

    assert assigns(:offer)
    assert_response :success
    assert_template :edit
    assert_template partial: 'offers/_step_3'
    assert_select "button.save_progress"
  end

  test 'edit after completing step3' do
    offer = create(:offer_step_3, merchant: @merchant)
    assert_equal 3, offer.step
    get :edit, id: offer.to_param

    assert assigns(:offer)
    assert_response :success
    assert_template :edit
    assert_template partial: 'offers/_step_4'
    assert_select "button.save_progress", false
  end

  test 'edit after completing step4' do
    offer = create(:offer_step_4, merchant: @merchant)
    assert_equal 4, offer.step
    get :edit, id: offer.to_param

    assert assigns(:offer)
    assert_response :success
    assert_template :edit
    assert_template partial: 'offers/_step_5'
    assert_select "button.save_progress", false
  end

  test 'edit w/ valid step parameter' do
    offer = create(:offer_step_1, merchant: @merchant)
    assert_equal 1, offer.step
    get :edit, id: offer.to_param, view_step: 1
    
    assert assigns(:offer)
    assert_response :success
    assert_template :edit
    assert_template partial: 'offers/_step_1'
  end

  test 'edit w/ invalid step parameter' do
    offer = create(:offer_step_1, merchant: @merchant)
    assert_equal 1, offer.step
    get :edit, id: offer.to_param, view_step: 1
    
    assert assigns(:offer)
    assert_response :success
    assert_template :edit
    assert_template partial: 'offers/_step_1'
  end

  test 'update w/ valid step 2 params' do
    offer = create(:offer_step_1, merchant: @merchant)
    assert_equal 1, offer.step

    put :update, id: offer.to_param, offer: exclusive_attributes_for(:offer_step_2)

    assert assigns(:offer)
    assert_equal 2, assigns(:offer).step, "Should increment step"
    assert_redirected_to edit_offer_path(offer)
  end

  test 'update w/ invalid params' do
    offer = create(:offer_step_1, merchant: @merchant)
    assert_equal 1, offer.step

    put :update, id: offer.to_param, offer: {}

    assert assigns(:offer)
    assert_equal 2, assigns(:offer).step, "Should not increment step"
    assert_template :edit
    assert_template partial: 'offers/_step_2'
  end

  test 'update step 2 offer for step 1 w/ valid params' do
    offer = create(:offer_step_2, merchant: @merchant, type: 'prepaid')
    assert_equal 2, offer.step
    put :update, id: offer.to_param, view_step: 1, offer: { type: 'free' }
    assert_redirected_to edit_offer_path(offer)
    
    offer.reload
    assert_equal 1, offer.step, "Should increment step back to 1"
    assert offer.free?, "Should have save the offer type as free"
  end

  test 'update step 2 offer for step 1 w/ invalid params' do
    offer = create(:offer_step_2, merchant: @merchant, type: 'prepaid')
    assert_equal 2, offer.step

    put :update, id: offer.to_param, view_step: 1, offer: { type: '' }
    assert_template :edit
    assert_template partial: 'offers/_step_1'
    
    offer = assigns(:offer)
    assert_equal 1, offer.step, "Should increment step back to 1"
    assert offer.invalid?, "The offer should be invalid" 
  end
  
  context 'target params' do
    should 'remove blank target params' do
      params = { offer: { target_all: 0, target_age_ranges: ['18-34', ''], target_genders: [''], target_annual_incomes: ['', 'test'] }}
      clean_params = { target_all: 0, target_age_ranges: ["18-34"], target_genders: [], target_annual_incomes: ['test'] }
      @controller.expects(:params).returns params
      assert_equal clean_params, @controller.send(:sanitized_offer_params)
    end

    should 'accept nil offer params' do
      @controller.expects(:params).returns({ offer: nil })
      assert_equal nil, @controller.send(:sanitized_offer_params)
    end

    should 'accept nil params' do
      @controller.expects(:params).returns nil
      assert_equal nil, @controller.send(:sanitized_offer_params)
    end
  end
end
