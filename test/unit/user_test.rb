require_relative '../test_helper'

class UserTest < ActiveSupport::TestCase

  context 'valid?' do
    setup do
      @user = create(:system_user)
    end

    should 'require username' do
      @user.update_attributes username: nil
      assert_equal false, @user.valid?
      assert_match "can't be blank", @user.errors[:username].first
    end

    should 'require a unique username' do
      @user.update_attributes username: 'samename'
      @second_user = build(:system_user, username: 'samename')
      assert !@second_user.valid?
      assert_match(/has already been taken/, @second_user.errors[:encrypted_username].first)
      @second_user.username = 'something different'
      assert @second_user.valid?
    end

    context 'email' do
      should 'require email' do
        @user.update_attributes email: nil
        assert_equal false, @user.valid?
        assert_match "can't be blank", @user.errors[:email].first
      end

      should 'require a unique email' do
        @user.update_attributes email: 'same@email.com'
        @second_user = build(:system_user, email: 'same@email.com')
        assert !@second_user.valid?
        assert_match(/has already been taken/, @second_user.errors[:encrypted_email].first)
        @second_user.email = 'different@email.com'
        assert @second_user.valid?
      end

      should "not accept an invalid email" do
        ['invalid address', 'invalid@domain', 'invalid@domain.', '@domain.com'].each do |invalid_email|
          @user.email = invalid_email
          assert @user.invalid?, 'user was not invalid'
          assert !@user.errors[:email].blank?, 'No validation errors found'
          assert_match @user.errors[:email].first, /invalid/
        end
      end

      should "accept a valid email" do
        ["valid_address@domain.com", "valid_address+2@domain.com", "valid.address@domain.co.uk"].each do |valid_email|
          @user.email = valid_email
          @user.valid?
          assert_blank @user.errors[:email], "user was invalid: #{@user.errors.full_messages}"
        end
      end
    end

    should 'require first_name' do
      @user.update_attributes first_name: nil
      assert_equal false, @user.valid?
      assert_match "can't be blank", @user.errors[:first_name].first
    end

    should 'require last_name' do
      @user.update_attributes last_name: nil
      assert_equal false, @user.valid?
      assert_match "can't be blank", @user.errors[:last_name].first
    end

    context 'password' do
      setup do
        @password = 'testing'
        @user = User.new(FactoryGirl.attributes_for(:system_user, password: @password, password_confirmation: @password))
      end

      should "accept a valid password and password_confirmation" do
        @user.password = @user.password_confirmation = "123TestPassword"
        @user.valid?
        assert_blank @user.errors[:password]
      end

      should "NOT accept a nil password on create" do
        @user.password = @user.password_confirmation = nil
        assert !@user.save
        assert_match(/can't be blank/, @user.errors[:password].first)
      end

      should "NOT accept a blank password on create" do
        @user.password = @user.password_confirmation = ''
        assert !@user.save
        assert_match(/can't be blank/, @user.errors[:password].first)
      end

      should "accept a blank  password on udpate but not update it" do
        pw = 'foobarbaz'
        @user = create :system_user, password: pw, password_confirmation: pw
        assert_equal @user, User.authenticate(@user.username, pw)
        @user.password = @user.password_confirmation = ''
        assert @user.save
        assert_equal @user, User.authenticate(@user.username, pw)
      end

      should "accept a nil password on udpate but not update it" do
        pw = 'foobarbaz'
        @user = create :system_user, password: pw, password_confirmation: pw
        assert_equal @user, User.authenticate(@user.username, pw)
        @user.password = @user.password_confirmation = nil
        assert @user.save
        assert_equal @user, User.authenticate(@user.username, pw)
      end

      should "NOT accept a password of length 7" do
        @user.password = @user.password_confirmation = "123Test"
        assert @user.invalid?
        assert_match(/is too short \(minimum is 8 characters\)/, @user.errors[:password].first)
      end

      should "NOT accept a password of length 16" do
        @user.password = @user.password_confirmation = "123Tests123Tests"
        assert @user.invalid?
        assert_match(/is too long \(maximum is 15 characters\)/, @user.errors[:password].first)
      end

      should "NOT accept a password of 4 sequential numbers at the start" do
        @user.password = @user.password_confirmation = "1235TestTest"
        @user.valid?
        assert @user.errors[:password].include?( "For security reasons your password cannot contain 4 sequential numbers.  Please choose another password." )
      end      

      should "NOT accept a password of 4 sequential numbers in the middle" do
        @user.password = @user.password_confirmation = "Test1234Test"
        @user.valid?
        assert @user.errors[:password].include?( "For security reasons your password cannot contain 4 sequential numbers.  Please choose another password." )
      end

      should "NOT accept a password of 4 sequential numbers at the end" do
        @user.password = @user.password_confirmation = "TestTest1235"
        @user.valid?
        assert @user.errors[:password].include?( "For security reasons your password cannot contain 4 sequential numbers.  Please choose another password." )
      end     

      should "allow special characters" do
        ['!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '?', '_'].each do |char|
          @user.password = @user.password_confirmation = "TestTest123#{char}"
          @user.valid?
          assert @user.errors[:password].blank?
          #assert @user.errors[:password].include?( 'Please enter a password using the letters "a" to "z" and numbers "0" to "9"' ), "Password cannot contain the character: #{char}"
        end
      end 
    end
  end

  context '.authenticate' do
    setup do
      @password = 'foobarbaz'
      @system_user = create(:system_user, password: @password , password_confirmation: @password )
    end

    should 'authenticate using email address' do
      assert_equal @system_user, User.authenticate(@system_user.email, @password)
    end

    should 'authenticate using username' do
      assert_equal @system_user, User.authenticate(@system_user.username, @password)
    end

    should 'not authenticate inactive users' do
      @system_user.update_attributes active: false
      assert_equal nil, User.authenticate(@system_user.email, @password)
    end

    should 'return nil when no user exist' do
      assert_equal nil, User.authenticate(@system_user.username, 'no_password')
    end
  end

  context '#display_name' do
    should 'use first and last name to make a display name' do
      @system_user = create(:system_user, first_name: 'first', last_name: 'last')
      assert_equal 'first last', @system_user.display_name
    end
  end

  context "#merchant" do
    should "respond to merchant association" do
      @user = build(:user)
      assert @user.respond_to? :merchant
    end
  end

  context "roles" do

    setup do
      @user = build(:user)
    end

    should "not validate if no roles are selected" do
      @user.is_merchant = false
      @user.is_sales = false
      @user.is_admin = false
      @user.is_system = false
      assert !@user.valid?
    end

    should "validate if a role is selected" do
      @user.is_merchant = true
      @user.is_sales = false
      @user.is_admin = false
      @user.is_system = false
      assert @user.valid?
    end

    context "#only_has_merchant_role?" do
      should 'return true when the user only has the merchant role' do
         @user = create :user, is_merchant: true, is_system: false, is_admin: false, is_sales: false
         assert @user.only_has_merchant_role?
      end

      should 'return false when the user does not have the merchant role' do
         @user = create :user, is_merchant: false, is_system: true, is_admin: false, is_sales: false
         assert !@user.only_has_merchant_role?
      end

      should 'return false when the user has the merchant and another role' do
         @user = create :user, is_merchant: true, is_system: false, is_admin: false, is_sales: false
        [:is_system=, :is_admin=, :is_sales=].each do |role_setter|
          @user.send(role_setter, true)
          assert !@user.only_has_merchant_role?
          @user.send(role_setter, false)
        end
      end
    end
  end
end
