class PasswordValidator < ActiveModel::EachValidator
  
  def validate_each(record, attribute, value)
    ensure_no_more_than_3_sequential_numbers(record, attribute, value)
    #ensure_valid_characters(record, attribute, value)
  end

  def ensure_valid_characters(record, attribute, value)
    return unless value.present?
    if value.match(/(\W|_)+/)
      record.errors.add( attribute, options[:message] || 'Please enter a password using the letters "a" to "z" and numbers "0" to "9"')
    end
  end
  
  def ensure_no_more_than_3_sequential_numbers(record, attribute, value)
    return unless value.present?    
    if value.match(/\d{4,}/)
      record.errors.add( attribute, options[:message] || "For security reasons your password cannot contain 4 sequential numbers.  Please choose another password.")
    end
    
  end
  
end
