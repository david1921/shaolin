require_relative '../test_helper'

class RegistrationsControllerTest < ActionController::TestCase

  test '#new' do
    get :new
    assert_response :success
    assert_template :new
    assert_not_nil  assigns(:registration)
    assert_select 'form.new_registration' do
      assert_select "input[name='registration[gross_annual_turnover]']"
      assert_select "input[name='step'][value='gross_annual_turnover']"
    end
  end

  test '#create (gross_annual_turnover, valid)' do
    assert_difference 'Merchant.count' do
      post :create, registration: attributes_for(:registration_small).except(:attrs_to_validate), step: :gross_annual_turnover
    end
    assert_redirected_to edit_registration_path(Merchant.last.uuid)
  end

  test '#create invalid' do
    post :create, registration: { gross_annual_turnover: "0.0" }, step: :gross_annual_turnover
    assert_response :ok
    assert_template :new
  end

  test '#update (valid)' do
    user_password_attrs = { password: 'test123test', password_confirmation: 'test123test' }
    registration = create(:registration_gross_annual)
    assert registration.small?
    post :update, id: registration.uuid, registration: attributes_for(:registration_large).merge(business_address_attributes: attributes_for(:address)).except(:attrs_to_validate).merge(user_attributes: user_password_attrs)

    assert_redirected_to confirmation_registration_path(registration.id)
  end

  test '#update (invalid - email already taken)' do
    # the reg controller does some crazy stuff to build a nested_attributes_for :user and has to manually copy user errors back to the merchant.
    create :admin_user, email: 'test@test.com' # user exits with same email as new merchant
    user_password_attrs = { password: 'test123test', password_confirmation: 'test123test' }
    registration = create(:registration_gross_annual)
    post :update, id: registration.uuid, registration: attributes_for(:registration_large, contact_work_email_address: 'test@test.com').except(:attrs_to_validate).merge(user_attributes: user_password_attrs)
    assert_match(/has already been taken/, assigns(:registration).errors[:contact_work_email_address].first)
    assert_response :ok
    assert_template :edit
  end

  test '#confirmation' do
    get :confirmation, id: create(:merchant).id
    assert_response :success
    assert_template :confirmation
    assert_not_nil assigns(:registration)
    assert_select "h1", "Confirmation"
    assert_select "h3", "Thank you for your enquiry. We'll be in touch soon."
  end

end

