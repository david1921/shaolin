require_relative '../test_helper'

class InfoRequestTest < ActiveSupport::TestCase
  
  setup do
    @valid_attributes = {
      title: "Mr",
      first_name: "Jon",
      last_name: "Smith",
      business_name: "Jon Smith Inc",
      email: "jon@jonsmithinc.com",
      telephone: "020 7243 2319",
      additional_details: "This is my additional details about my business."
    }
  end
  
  test "should be valid with valid attributes" do
    info_request = InfoRequest.new( @valid_attributes )
    assert info_request.valid?
  end

  test "should not be valid with missing title" do
    info_request = InfoRequest.new( @valid_attributes.except(:title) )
    assert !info_request.valid?, "info request should not be valid with no title"
  end
  
  test "should be invalid without First Name" do
    info_request = InfoRequest.new( @valid_attributes.merge( first_name: "" ))
    assert !info_request.valid?, "info request should not be valid without first name"
    assert_not_nil info_request.errors[:first_name], "should have error message for First Name"
  end

  test "should be invalid without Last Name" do
    info_request = InfoRequest.new( @valid_attributes.merge( last_name: "" ))
    assert !info_request.valid?, "info request should not be valid without last name"
    assert_not_nil info_request.errors[:last_name], "should have error message for Last Name"
  end

  test "should be invalid without Business Name" do
    info_request = InfoRequest.new( @valid_attributes.merge( business_name: "" ))
    assert !info_request.valid?, "info request should not be valid without business name"
    assert_not_nil info_request.errors[:business_name], "should have error message for Business Name"
  end

  test "should be invalid with blank email address" do
    info_request = InfoRequest.new( @valid_attributes.merge( email: "" ) )
    assert !info_request.valid?, "info request should not be valid with blank email"
    assert_not_nil info_request.errors[:email], "should have error message for email attribute"
  end

  test "should be invalid with invalid email address" do
    info_request = InfoRequest.new( @valid_attributes.merge( email: "blah" ) )
    assert !info_request.valid?, "info request should not be valid with invalid email"
    assert_not_nil info_request.errors[:email], "should have error message for email attribute"
  end  

  test "should be invalid with blank telephone address" do
    info_request = InfoRequest.new( @valid_attributes.merge( telephone: "" ) )
    assert !info_request.valid?, "info request should not be valid with blank telephone"
    assert_not_nil info_request.errors[:telephone], "should have error message for telephone attribute"
  end 

  test "should be invalid with blank query description" do
    info_request = InfoRequest.new( @valid_attributes.merge( additional_details: "" ) )
    assert !info_request.valid?, "info request should not be valid with blank query description" 
    assert_not_nil info_request.errors[:additional_details], "should have error message for query description"
  end

  test "should be invalid with addition_details over 500 characters" do
    info_request = InfoRequest.new( @valid_attributes.merge( additional_details: "x"*501) )
    assert !info_request.valid?, "info request should not be vaild when additonal_details is over 500 characters"
    assert_not_nil info_request.errors[:additional_details], "should have error message for query description"
  end
  
  test "should be valid with a bespoke contact title" do
    info_request = InfoRequest.new( @valid_attributes.merge( title: "invalid title" ) )
    assert !info_request.valid?, "info request should not be vaild without a bespoke contact title"
    assert_present info_request.errors[:title], "should have error message for title attribute"
    info_request.title = "Lord"
    assert info_request.valid?, "info request should be valid with a bespoke contact title"
  end
  
end