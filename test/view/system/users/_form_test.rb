require_relative '../../../test_helper'

module System
  class FormPartialTest < ActionView::TestCase
    setup do
      ActionController::Base.prepend_view_path 'app/views/system/users'
    end

    should 'render all the new attributes' do
      @user = build :system_user
      with_form_fields do
        render template: 'new'
      end
    end

    should 'render all the edit attributes' do
      @user = create :system_user
      with_form_fields do
        render template: 'edit'
      end
    end

    def with_form_fields
      yield
      assert_select "input[name='user[username]'][value='#{@user.username}']"
      assert_select "input[name='user[email]'][value='#{@user.email}']"
      assert_select "input[name='user[first_name]'][value='#{@user.first_name}']"
      assert_select "input[name='user[last_name]'][value='#{@user.last_name}']"
      assert_select "input[name='user[is_system]']"
      assert_select "input[name='user[is_admin]']"
      assert_select "input[name='user[is_sales]']"
      assert_select "input[name='user[is_merchant]']"
      assert_select "input[name='user[password]']"
      assert_select "input[name='user[password_confirmation]']"
    end
  end
end
