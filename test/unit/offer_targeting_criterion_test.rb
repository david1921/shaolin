require_relative "../test_helper"

class OfferTargetingCriterionTest < ActiveSupport::TestCase

  context "validations" do

    setup do
      @targeting_criterion = build(:offer_targeting_age_criterion)
      assert @targeting_criterion.valid?, "@targeting_criterion should be valid"
    end
    
    should "require an offer_id" do
      @targeting_criterion.offer_id = nil
      assert @targeting_criterion.invalid?, "@targeting_criterion should be invalid with a missing offer_id"
    end

    should "require a criterion_type" do
      @targeting_criterion.criterion_type = nil
      assert @targeting_criterion.invalid?, "@targeting_criterion should be invalid with a missing criterion_type"
    end
    
    should "require a value" do
      @targeting_criterion.value = nil
      assert @targeting_criterion.invalid?, "@targeting_criterion should be invalid with a missing value"
    end

  end

  context ".age" do
    
    should "return only age criteria" do
      age_criteria = create :offer_targeting_age_criterion
      gender_criteria = create :offer_targeting_gender_criterion
      assert_equal [age_criteria], OfferTargetingCriterion.age
    end

  end

  context "age criteria" do
    
    should "allow only the values from TARGET_AGE_RANGES" do
      assert_equal %w(18-34 35-55 55+), OfferTargetingCriterion::TARGET_AGE_RANGES
      target_criterion = create :offer_targeting_age_criterion
      assert target_criterion.valid?
      OfferTargetingCriterion::TARGET_AGE_RANGES.each do |age_range|
        target_criterion.value = age_range
        assert target_criterion.valid?, "target_criterion for age #{age_range} should be valid"
      end
      target_criterion.value = "xyz"
      assert target_criterion.invalid?, "target_criterion for age #{target_criterion.value} should not be valid"
    end

  end

end
