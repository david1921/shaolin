class MobilePhoneNumber
  attr_reader :problems

  VALID_MOBILE_LENGTH = 11
  VALID_MOBILE_PREFIX = "07"

  PROBLEM_ADVICE = {
    phone_mobile_invalid_length: "Mobile numbers must be 11 characters in length",
    phone_mobile_invalid_prefix: "Mobile numbers must start with 07"
  }

  def self.create value
    new value
  end

  def initialize value
    @problems = Hash.new
    give_advice_for :phone_mobile_invalid_length unless value.length == VALID_MOBILE_LENGTH
    give_advice_for :phone_mobile_invalid_prefix unless value[0..1] == VALID_MOBILE_PREFIX
  end

  private
  def give_advice_for problem
    @problems[problem] = PROBLEM_ADVICE.fetch problem
  end
end
