require_relative '../../../../test_helper'

module Admin
  module Merchants
    module MerchantOwners
      class IndexPartialTest < ActionView::TestCase

        helper do
         def action_name
           @action_name
         end
        end

        def setup
          ActionController::Base.prepend_view_path 'app/views/admin/merchants/merchant_owners/'
          @merchant_owner = create :merchant_owner
          @merchant = @merchant_owner.merchant
        end

        should 'have an editable  merchant owner table' do
          @action_name = 'edit'
          render partial: 'index'
          assert_select 'a', 'Create new owner'
          assert_select "div[id='merchant_owners_table']" do
            assert_select 'li', 'Title'
            assert_select 'li', 'First Name'
            assert_select 'li', 'Last Name'
            assert_select 'li', 'Postal Code'
            assert_select 'li', 'Address'
            assert_select 'li', 'Actions'
          end

          assert_select "ul[id=owner_row_#{@merchant_owner.id}]" do
            assert_select 'li', @merchant_owner.title
            assert_select 'li', @merchant_owner.first_name
            assert_select 'li', @merchant_owner.last_name
            assert_select 'li', @merchant_owner.home_postal_code
            assert_select 'li', @merchant_owner.home_address
            assert_select "li[id='owner_row_#{@merchant_owner.id}_actions']" do
              assert_select 'a', 'edit'
              assert_select 'a', 'delete'
            end
          end
        end

        should 'have a merchant owner table' do
          @action_name = 'show'
          render partial: 'index'

          assert_select 'a', text: 'Create new owner', count: 0
          assert_select "div[id='merchant_owners_table']" do
            assert_select 'li', 'Title'
            assert_select 'li', 'First Name'
            assert_select 'li', 'Last Name'
            assert_select 'li', 'Postal Code'
            assert_select 'li', 'Address'
            assert_select 'li', text: 'Actions', count: 0
          end

          assert_select "ul[id=owner_row_#{@merchant_owner.id}]" do
            assert_select 'li', @merchant_owner.title
            assert_select 'li', @merchant_owner.first_name
            assert_select 'li', @merchant_owner.last_name
            assert_select 'li', @merchant_owner.home_postal_code
            assert_select 'li', @merchant_owner.home_address
          end
        end
      end
    end
  end
end


