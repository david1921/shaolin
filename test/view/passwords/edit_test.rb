require_relative '../../test_helper'

module Passwords
  class EditTemplateTest < ActionView::TestCase
    setup do
      ActionController::Base.prepend_view_path 'app/views/passwords'
    end

    should 'render the reset password template' do
      @user = create :system_user
      render template: 'edit'
      assert_select "input[name='user[password]']"
      assert_select "input[type='submit'][value='Create new password']"
    end
  end
end

