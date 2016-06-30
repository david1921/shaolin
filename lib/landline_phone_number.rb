class LandlinePhoneNumber
  VALID_LANDLINE_LENGTHS = (10..11)
  VALID_LANDLINE_PREFIXES = ["01", "02", "03", "07", "08"]

  PROBLEM_ADVICE = {
    phone_landline_invalid_length: "Landlines must be between 10 and 11 digits long",
    phone_landline_invalid_prefix: "Landlines must start 01, 02, 03, 07 or 08 only"
  }

  attr_reader :problems

  def self.create value
    new value
  end

  def initialize value
    @problems = Hash.new
    give_advice_for :phone_landline_invalid_length unless VALID_LANDLINE_LENGTHS.include? value.length
    give_advice_for :phone_landline_invalid_prefix unless VALID_LANDLINE_PREFIXES.include? value[0..1]
  end

  private
  def give_advice_for problem
    @problems[problem] = PROBLEM_ADVICE.fetch problem
  end
end
