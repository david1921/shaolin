class EntityNameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    not_nil_and_has_only_letters_numbers_commas_dashes_and_apostrophes = 
      value && !value.match(/^[a-z0-9\s.\-,_']+$/i)
    record.errors.add(attribute, :bad_entity_name) if not_nil_and_has_only_letters_numbers_commas_dashes_and_apostrophes
  end
end