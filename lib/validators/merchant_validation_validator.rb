class MerchantValidationValidator < ActiveModel::Validator
  def validate(record)
    return unless record.status_changed? && record.status == 'approved'
  end
end
