class LandlinePhoneValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    unless value.blank?
      LandlinePhoneNumber.create(value).problems.each do |problem, advice|
        record.errors.add(attribute, problem)
      end
    end
  end

end
