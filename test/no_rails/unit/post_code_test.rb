require_relative '../test_helper'
require File.expand_path('lib/postcode')

class PostcodeTest < Test::Unit::TestCase

  should "allow valid postcodes" do
    assert_equal 0, Postcode.create("AA99 9AA").problems.size
  end

  should "allow valid postcodes without spaces" do
    assert_equal 0, Postcode.create("AA999AA").problems.size
  end

  should "allow valid postcodes with lower case alpha characters" do
    assert_equal 0, Postcode.create("aa99 9aa").problems.size
  end

  should "not allow numbers as the first character of the outcode" do
    problems = Postcode.create("9A9 9AA").problems
    assert_equal 1, problems.size
    assert_includes problems, :postcode_outcode_invalid_character
  end

  should "not allow three consecutive letters in the outcode" do
    problems = Postcode.create("AAA9 9AA").problems
    assert_equal 1, problems.size
    assert_includes problems, :postcode_outcode_invalid_postcode_area
  end

  should "not allow alpha-only values in the outcode district" do
    problems = Postcode.create("AA 9AA").problems
    assert_equal 1, problems.size
    assert_includes problems, :postcode_outcode_numeric_district_required
  end

  should "not allow outcode district numbers larger than 99" do
    problems = Postcode.create("AA999 9AA").problems
    assert_equal 1, problems.size
    assert_includes problems, :postcode_outcode_numeric_district_too_large
  end

  should "not allow more than one alpha character in the outcode district" do
    problems = Postcode.create("AA9AA 9AA").problems
    assert_equal 1, problems.size
    assert_includes problems, :postcode_outcode_too_many_alpha_chars_in_district
  end

  should "not allow an invalid alpha character in the outcode district" do
    "ILOQZ".each_char do |invalid_char|
      problems = Postcode.create("AA9#{invalid_char} 9AA").problems
      assert_equal 1, problems.size, "Should not allow invalid character #{invalid_char} in outcode district"
      assert_includes problems, :postcode_outcode_invalid_character_in_district
    end
  end

  should "not allow a non-numeric character for the incode postcode sector" do
    problems = Postcode.create("AA9 AAA").problems
    assert_equal 1, problems.size, "Should not allow non-numeric characters in the incode sector"
    assert_includes problems, :postcode_incode_invalid_postcode_sector
  end

  should "not allow invalid characters in the incode postcode unit" do
    "CIKMOV".each_char do |invalid_char|
      problems = Postcode.create("AA9 9A#{invalid_char}").problems
      assert_equal 1, problems.size, "Should not allow invalid character #{invalid_char} in the incode unit"
      assert_includes problems, :postcode_incode_invalid_postcode_unit_alpha
    end
  end

  should "prevent non-alpha characters in the incode postcode unit" do
    problems = Postcode.create("AA9 99A").problems
    assert_equal 1, problems.size, "Should prevent non-alpha chars in incode postcode unit"
    assert_includes problems, :postcode_incode_non_alpha_in_postcode_unit
  end

  should "not allow missing outcode" do
    problems = Postcode.create("AA9").problems
    assert_equal 1, problems.size, "Should not allow mising outcode"
    assert_includes problems, :postcode_must_contain_outocde
  end
end
