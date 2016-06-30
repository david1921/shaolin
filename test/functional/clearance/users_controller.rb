require_relative '../../test_helper'

class Clearance::UsersControllerTest < ActionController::TestCase
  context 'sign_up' do
    should 'not allow sign_up' do
      get :new
      assert_response :redirect
      assert_redirected_to 'sign_in'
    end

    should 'not allow user creation' do
      post :create
      assert_response :redirect
      assert_redirected_to 'sign_in'
    end
  end
end

