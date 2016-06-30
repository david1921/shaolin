
require_relative '../../test_helper'

class MerchantsTest < ActiveSupport::TestCase

  context '#set_attrs_to_validate_on_save' do
    should 'always include trading_name' do
      merchant = build :merchant
      merchant.set_attrs_to_validate_on_save({})
      assert_equal [:trading_name], merchant.attrs_to_validate
    end

    should 'include all supplied merchant attributes' do
      merchant = build :merchant
      merchant.set_attrs_to_validate_on_save({ some_attribute: 'yes', beef: 'pork' })
      assert_equal [:some_attribute, :beef, :trading_name], merchant.attrs_to_validate
    end

    should 'skip privacy policy because it must be true and this is not enforced on save' do
      merchant = build :merchant
      merchant.set_attrs_to_validate_on_save({ privacy_policy: 'no', beef: 'pork' })
      assert_equal [:beef, :trading_name], merchant.attrs_to_validate
    end
  end

end
