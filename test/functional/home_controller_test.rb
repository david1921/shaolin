require_relative '../test_helper'

class HomeControllerTest < ActionController::TestCase
  tests :home

  context '#index' do
    should "redirect to the user's home page when different from home_path" do
      sign_in_as create :sales_user
      get :show
      assert_redirected_to @controller.current_user_home_path
    end

    should "render the home page when the user's home page is home_path" do
      sign_in_as create :merchant_user
      get :show
      assert_response :success
      assert_template 'index'
    end

    should "render the home page when a user is not signed in" do
      get :show
      assert_response :success
      assert_template 'index'
    end
  end
end
