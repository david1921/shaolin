require_relative '../../test_helper'

module Dashboard 
  class IndexTest < ActionView::TestCase
    setup do
      ActionController::Base.prepend_view_path 'app/views/dashboard'
    end

    helper do
      def current_user
        @user
      end
    end

    context 'system user' do
      should 'render system user links' do
        @user = create :system_user
        render template: 'index' 
        assert_system_user_links
        assert_select "div[id='sales_user_links']", 0
        assert_select "div[id='admin_user_links']", 0
      end
    end

    context 'admin_user' do
      should 'render admin user links' do
        @user = create :admin_user
        render template: 'index'
        assert_admin_user_links
        assert_select "div[id='sales_user_links']", 0
        assert_select "div[id='system_user_links']", 0
      end
    end

    context 'sales_user' do
      should 'render sales user links' do
        @user = create :sales_user
        render template: 'index'
        assert_sales_user_links
        assert_select "div[id='admin_user_links']", 0
        assert_select "div[id='system_user_links']", 0
      end
    end

    context 'supersuer' do
      should 'render all links' do
        @user = create(:user, is_system: true, is_admin: true, is_sales: true)
        render template: 'index'
        assert_system_user_links
        assert_sales_user_links
        assert_admin_user_links
      end
    end

    def assert_system_user_links 
      assert_select "div[id='system_user_links']" do
        assert_select 'a', 'Setup user'
        assert_select 'a', 'Search users'
      end
    end

    def assert_admin_user_links 
      assert_select "div[id='admin_user_links']" do
        assert_select 'a', 'Setup merchant'
        assert_select 'a', 'Search merchants'
      end
    end

    def assert_sales_user_links 
      assert_select "div[id='sales_user_links']" do
        assert_select 'a', 'Setup merchant'
        assert_select 'a', 'Search merchants'
      end
    end
  end
end

