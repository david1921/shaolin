module ValidationTestHelper

  def set_target(target)
    @target = target
  end

  def assert_length_range(attribute, min, max, character = 'x')
    set_attr attribute, character * (max + 1)
    assert_attribute_invalid attribute
    set_attr attribute, character * (min - 1)
    assert_attribute_invalid attribute
    set_attr attribute, character * max
    assert_attribute_valid attribute
    set_attr attribute, character * min
    assert_attribute_valid attribute
  end

  def assert_length_is(attribute, length, character = 'x')
    set_attr attribute, character * (length + 1)
    assert_attribute_invalid attribute
    set_attr attribute, character * (length - 1)
    assert_attribute_invalid attribute
    set_attr attribute, character * length
    assert_attribute_valid attribute
  end

  def assert_attribute_value_valid(attribute, value, message = nil)
    set_attr attribute, value
    assert_attribute_valid attribute, message
  end

  def assert_attribute_value_invalid(attribute, value, message = nil)
    set_attr attribute, value
    assert_attribute_invalid attribute, message
  end

  def assert_attribute_valid(attribute, message = nil)
    @target.valid?
    assert_blank @target.errors[attribute], message
  end

  def assert_attribute_invalid(attribute, message = nil)
    @target.invalid?
    assert_present @target.errors[attribute],
                   message.nil? ? "expected attribute #{attribute} to have errors, but it had none" : message
  end

private

  def set_attr(attribute, value)
    @target.send "#{attribute}=", value
  end

end
