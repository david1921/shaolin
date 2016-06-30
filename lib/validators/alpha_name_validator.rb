class AlphaNameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value && (value.match(/(\t|\n)/) || !value.match(/^[[:alpha:]][[:alpha:]|\s|\-]*$/))
      record.errors.add(attribute, :non_alpha_name)
    end
  end
end