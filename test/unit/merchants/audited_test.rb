require_relative '../../test_helper'

class Merchant::AuditedTest < ActiveSupport::TestCase
  context "audited" do
    setup do
      @merchant = build(:merchant)
    end

    should "have no versions on a new record" do
      assert @merchant.new_record?
      assert_empty @merchant.versions
    end

    should "have 1 version on a newly created record" do
      assert @merchant.save
      assert_equal 1, @merchant.version
      assert_equal 1, @merchant.versions.size, "should have added first initial version to versions table"
    end

    should "have 2 versions on a updated record" do
      assert @merchant.save
        assert @merchant.update_attributes( contact_first_name: "Sally", contact_last_name: "Changed Me" )
      assert_equal 2, @merchant.version
      assert_equal 2, @merchant.versions.size, "should have added second version to the versions table"
    end
  end
end
