require_relative '../test_helper'
require 'clearance/testing'

class SessionsControllerTest < ActionController::TestCase

  context "A sales user" do

    setup do
      @password = "foobarbaz"
      @sales_user = create :sales_user, username: "salesman", password: @password, password_confirmation:  @password
    end

    should "be redirected to dashboard_index_url on a successful authentication" do
      post :create, session: { email: "salesman", password: @password }
      assert_redirected_to dashboard_index_url 
    end

  end

  context "A merchant user" do
    setup do
      @password = 'foobarbaz'
      @merchant_user = create :merchant_user, username: "merchant", password: @password, password_confirmation:  @password
    end

  end

  context "Sign out" do
    context "as a merchant" do
      setup do
        antonio = create :merchant_user
        sign_in_as antonio
      end

      should "be redirected to the landing page" do
        delete :destroy
        assert_redirected_to root_url
      end
    end

    context "as a sales rep or administrator" do
      setup do
        @levene      = create :sales_user
        @williamson  = create :admin_user
      end

      should "be redirected to the sign in page" do
        sign_in_as @levene
        delete :destroy
        assert_redirected_to sign_in_url

        sign_in_as @williamson
        delete :destroy
        assert_redirected_to sign_in_url
      end
    end
  end

end
