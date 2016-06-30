ActiveSupport::TestCase.class_eval do
  def self.should_validate_attribute_with_validator(klass, attribute, validator_class, options={})
    should "validate #{attribute} using #{validator_class}" do
      verify_attribute_validated_with_validator(klass, attribute, validator_class, options)
    end
  end
end