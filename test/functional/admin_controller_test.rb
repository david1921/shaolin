require_relative "../test_helper"

class AdminControllerTest < ActionController::TestCase

  context "authentication" do
    should 'require a user' do
      @controller.expects(:deny_access)
      @controller.send(:authorize_admin_user) 
    end

    should 'require not allow other users' do
      [:sales_user, :system_user, :merchant_user].each do |user|
        sign_in_as create user
        @controller.expects(:deny_access)
        @controller.send(:authorize_admin_user) 
      end
    end

    should 'allow an admin user' do
      sign_in_as create :admin_user
      assert_equal nil, @controller.send(:authorize_admin_user)
    end
  end
end

