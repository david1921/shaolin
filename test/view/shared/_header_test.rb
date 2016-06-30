require_relative '../../test_helper'
require 'ostruct'

module Shared
  class HeaderPartialTest < ActionView::TestCase
    setup do
      ActionController::Base.prepend_view_path 'app/views/shared'
    end

    helper do
      def current_user
        OpenStruct.new(display_name: 'Irrelevant')
      end

      def signed_in?
        @signed_in
      end

      def signed_out?
        @signed_out
      end

      def current_user_home_path
        home_path
      end
    end

    def sign_in
      @signed_in = true
      @signed_out = false
    end

    def sign_out
      @signed_out = true
      @signed_in = false
    end

    context 'when signed in' do
      should 'render the signed_in information and navigation' do
        sign_in
        render 'shared/header'
        assert_select '.account_nav_content'
      end

    end

    context 'when signed out' do

      should 'render the login form' do
        sign_out
        render 'shared/header'
        assert_select '.account_nav_content', false, "no account navigation for signed out users"
        assert_select '.tabs', false, "no user navigation for signed out users"
      end

    end
  end
end
