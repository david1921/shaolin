
require_relative '../../test_helper'
require 'ostruct'

module Shared
  class UserNavTest < ActionView::TestCase
    setup do
      ActionController::Base.prepend_view_path 'app/views/shared'
    end

    helper do
      def current_user_home_path
        'some_crazy_path'
      end
    end


    context 'home link' do
      should 'render a home link using the current_user_home_path helper' do
        @current_user = create :merchant_user
        render partial: 'user_nav'
        assert_select "a[href='#{dashboard_index_path}']", 'Home'
      end
    end
  end
end
