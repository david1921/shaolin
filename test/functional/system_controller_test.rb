require_relative "../test_helper"

class SystemControllerTest < ActionController::TestCase

  context "authentication" do
    should 'require a user' do
      @controller.expects(:deny_access)
      @controller.send(:authorize_system_user) 
    end

    should 'not allow other users' do
      [:sales_user, :admin_user, :merchant_user].each do |user|
        sign_in_as create user
        @controller.expects(:deny_access)
        @controller.send(:authorize_system_user) 
      end
    end

    should 'allow a system user' do
      sign_in_as create :system_user
      assert_equal nil, @controller.send(:authorize_system_user)
    end
  end
end


