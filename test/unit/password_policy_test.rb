require_relative '../test_helper'

class PasswordPolicyTest < ActiveSupport::TestCase

  context ".generate_random_password" do
    
    should "generate an 8 character string" do
      assert_equal 8, PasswordPolicy.generate_random_password.length
    end

  end

  context ".assign_random_password_to" do
    
    should "assign the output of generate_random_password to the #password and #password_confirmation " +
           "attributes of its argument" do
      user = User.new
      assert_nil user.password
      assert_nil user.password_confirmation
      PasswordPolicy.expects(:generate_random_password).returns("somepass")      
      PasswordPolicy.assign_random_password_to(user)
      assert_equal "somepass", user.password
      assert_equal "somepass", user.password_confirmation
    end

  end

end
