require_relative "../test_helper"

class SalesControllerTest < ActionController::TestCase

  context "GET to :index" do

    should "redirect to the signin page for an anonymous user" do
      get :index
      assert_redirected_to sign_in_url
    end

    context "with a sales user" do

      setup do
        @sales_user = create :sales_user
        sign_in_as @sales_user
        get :index
        assert_response :success
        assert_template 'index'
      end

    end

  end

  context "authentication" do
    should 'require a user' do
      @controller.expects(:deny_access)
      @controller.send(:authorize_sales_user) 
    end

    should 'require not allow other users' do
      [:admin_user, :system_user, :merchant_user].each do |user|
        sign_in_as create user
        @controller.expects(:deny_access)
        @controller.send(:authorize_sales_user) 
      end
    end

    should 'allow a sales user' do
      sign_in_as create :sales_user
      assert_equal nil, @controller.send(:authorize_sales_user)
    end
  end
end
