require_relative '../test_helper'

class MerchantTest < ActiveSupport::TestCase
  context 'belongs_to merchant' do
    setup do
      @merchant_owner = create :merchant_owner, merchant: nil
    end

    should 'not belong to an merchant' do
      assert_equal nil, @merchant_owner.merchant, 'should not have an merchant'
    end

    should 'belong to an merchant' do
      @merchant_owner.merchant = create :merchant
      assert_not_nil @merchant_owner.merchant
    end
  end

  context "#valid?" do

    should "be valid" do
      owner = build :merchant
      assert owner.valid?
    end

    context ":title" do
      should "accept only a Bespoke contact title" do
        owner = build :merchant_owner
        ["", "Judge"].each do |invalid_title|
          owner.title = invalid_title
          assert owner.invalid?
          assert_match(/not included/, owner.errors[:title].first)
        end
        owner.title = "Lady"
        assert owner.valid?
      end
    end

    context ":first_name" do
      should "be required" do
        owner = build :merchant_owner, first_name: nil
        assert !owner.valid?
        assert_match(/can't be blank/, owner.errors[:first_name].first)
      end
    end

    context ":last_name" do
      should "be required" do
        owner = build :merchant_owner, last_name: nil
        assert !owner.valid?
        assert_match(/can't be blank/, owner.errors[:last_name].first)
      end
    end
  end

  context "#valid_titles" do
    should "define valid titles using Bespoke::Contact::TITLES" do
      owner = MerchantOwner.new
      assert_equal Bespoke::Contact::TITLES, owner.valid_titles
    end
  end
end
