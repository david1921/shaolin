class EncryptedUniquenessValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.present?

    other_record_with_same_value = if record.persisted?
      record.class.send("find_by_#{attribute}", value, conditions: ("id != %d" % record.id))
    else
      record.class.send("find_by_#{attribute}", value)
    end

    record.errors.add(attribute, :taken) if other_record_with_same_value.present?
  end
end
