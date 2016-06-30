require_relative '../test_helper'

class DashboardControllerTest < ActionController::TestCase
  context '#index' do
    should 'render the index template for all roles' do
      [:system_user, :sales_user, :admin_user].each do |user|
        sign_in_as create(user)
        get :index
        assert_response :ok
        assert_template 'index'
      end
    end

    should 'require a user' do
      get :index
      assert_response :redirect
      assert_redirected_to 'http://test.host/sign_in'
    end
  end
end

