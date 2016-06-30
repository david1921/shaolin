require_relative '../../test_helper'

require 'active_model'

class BankAccountNumberValidator::ValidationTest < ActiveSupport::TestCase
  class Validatable
    include ActiveModel::Validations
    validates :bank_account_number, :bank_account_number => true
  end

  setup do
    @validatable = Validatable.new
  end

  context "bank account numbers" do
    should "not validate on nil" do
      @validatable.stubs(:bank_account_number).returns(nil)
      assert @validatable.valid?, "Should allow nil"
    end

    should "only consist of digits" do
      @validatable.stubs(:bank_account_number).returns("a12345z")
      assert @validatable.invalid?, "Should not allow alpha characters"
      assert_includes @validatable.errors[:bank_account_number], "Please use numbers only"

      @validatable.stubs(:bank_account_number).returns("?1245!")
      assert @validatable.invalid?, "Should not allow symbol characters"
      assert_includes @validatable.errors[:bank_account_number], "Please use numbers only"

      @validatable.stubs(:bank_account_number).returns("1234567")
      assert @validatable.valid?, "Should allow only digits"
    end

    should "be between 7 and 8 digits long" do
      @validatable.stubs(:bank_account_number).returns("123456")
      assert @validatable.invalid?, "Should not allow less than 7 characters"
      assert_includes @validatable.errors[:bank_account_number], "The Bank account number must be at least 7 digits long"

      @validatable.stubs(:bank_account_number).returns("123456789")
      assert @validatable.invalid?, "Should not allow more than 8 characters"
      assert_includes @validatable.errors[:bank_account_number], "The Bank account number must be at no more than 8 digits long"

      @validatable.stubs(:bank_account_number).returns("1234567")
      assert @validatable.valid?, "Should allow 7 characters"

      @validatable.stubs(:bank_account_number).returns("12345678")
      assert @validatable.valid?, "Should allow 8 characters"
    end

    should "be 8 digits long if it begins with a '20' prefix" do
      @validatable.stubs(:bank_account_number).returns("2012345")
      assert @validatable.invalid?, "Should not allow a '20' prefix that's not 8 digits long"
      assert_includes @validatable.errors[:bank_account_number], "The sort code you have entered indicates a Barclays Bank Account, please check the account details entered which must be 8 numeric characters long"

      @validatable.stubs(:bank_account_number).returns("20123456")
      assert @validatable.valid?, "Should allow a '20' prefix that's 8 digits long"
    end
  end
end
