class Postcode
  PROBLEM_ADVICE = {
    postcode_outcode_invalid_character: "Outcode should not start with a digit", 
    postcode_outcode_invalid_postcode_area: "Outcode should start with at most two alpha characters", 
    postcode_outcode_numeric_district_required: "Outcode should contain a numeric district code", 
    postcode_outcode_numeric_district_too_large: "Outcode district should be no greater than 99", 
    postcode_outcode_too_many_alpha_chars_in_district: "Outcode district should be no greater than 99", 
    postcode_outcode_invalid_character_in_district: "Outcode district cannot contain ILOQZ", 
    postcode_incode_invalid_postcode_sector: "Incode sector should be numeric", 
    postcode_incode_invalid_postcode_unit_alpha: "Incode unit cannot contain characters CIKMOV", 
    postcode_incode_non_alpha_in_postcode_unit: "Incode unit must be a permitted alpha character",
    postcode_must_contain_outocde: "Must contain an outcode"
  }

  attr_reader :problems

  def self.create value
    new value
  end

  def initialize value
    @problems = Hash.new
    postcode = value.gsub(/\s/, '').upcase
    outcode, incode = postcode[0...postcode.length-3], postcode[-3..-1]
    if outcode.blank?
      give_advice_for :postcode_must_contain_outocde if postcode.size < 4
      return
    end
    give_advice_for :postcode_outcode_invalid_character if outcode[0].match(/\d/) 
    give_advice_for :postcode_outcode_invalid_postcode_area if outcode.match(/[A-Z]{3}/)
    give_advice_for :postcode_outcode_numeric_district_required unless outcode.match(/[A-Z]{1,2}\d{1,2}/)
    give_advice_for :postcode_outcode_numeric_district_too_large if outcode.match(/[A-Z]{1,2}\d{3,}/)
    give_advice_for :postcode_outcode_too_many_alpha_chars_in_district if outcode.match(/\d[A-Z]{2,}/)
    give_advice_for :postcode_outcode_invalid_character_in_district if outcode.match(/\d[IOQLZ]/)
    give_advice_for :postcode_incode_invalid_postcode_sector unless incode.match(/\A\d{1}/)
    give_advice_for :postcode_incode_invalid_postcode_unit_alpha if incode.match(/[CIKMOV]/)
    give_advice_for :postcode_incode_non_alpha_in_postcode_unit unless incode.match(/\A.[A-Z]/)
  end

  private
  def give_advice_for problem
    @problems[problem] = PROBLEM_ADVICE.fetch problem
  end
end
