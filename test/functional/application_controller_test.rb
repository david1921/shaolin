require_relative '../test_helper'

class TestableController < ApplicationController
  before_filter :authorize

  def index
    render text: 'test'
  end
end

class ApplicationControllerTest < ActionController::TestCase
  tests :testable

  context '#current_user_home_path' do
    should 'be the home page for merchant users' do
      sign_in_as create :merchant_user
      assert home_path, @controller.current_user_home_path
    end

    should 'be the dashboard for non-merchant users' do
      sign_in_as create :system_user
      assert dashboard_index_path, @controller.current_user_home_path
      sign_in_as create :admin_user
      assert dashboard_index_path, @controller.current_user_home_path
      sign_in_as create :sales_user
      assert dashboard_index_path, @controller.current_user_home_path
    end
  end



  context '#default_pagination_params' do
    setup do
      @user = FactoryGirl.create(:system_user)
      sign_in_as @user
    end

    should 'link params[:page] to pagination argument' do
      with_testable_route do
        get :index, page: 10
        assert_equal '10', @controller.send(:default_pagination_params)[:page] 
      end
    end

    should 'set the default items per page' do
      assert_equal 25, @controller.send(:default_pagination_params)[:per_page]
    end
  end

  context '#authorize' do
    should 'not allow access when no user is logged in' do
      with_testable_route do
        get :index
        assert_response 302
        assert_redirected_to 'http://test.host/sign_in'
      end
    end

    should 'not allow access when user is inactive' do
      with_testable_route do
        @user = FactoryGirl.create(:system_user, active: false)
        sign_in_as @user
        get :index
        assert_response :redirect
        assert_redirected_to 'http://test.host/'
      end
    end

    should 'allow access when user is logged in' do
      with_testable_route do
        @user = FactoryGirl.create(:system_user)
        sign_in_as @user
        get :index
        assert_response :ok
      end
    end
  end

  def with_testable_route 
    with_routing do |set|
      set.draw do
        resources :testable
        resource  :session, :controller => 'clearance/sessions',
          :only => [:create, :new, :destroy]
        match 'sign_in' => 'clearance/sessions#new', :as => 'sign_in'
      end
      yield
    end
  end
end

