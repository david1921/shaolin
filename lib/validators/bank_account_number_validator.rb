class BankAccountNumberValidator < ActiveModel::EachValidator
  VALID_LENGTH_RANGE = 7..8
  VALID_BARCLAYS_PREFIX = '20'
  VALID_BARCLAYS_LENGTH = 8

  def validate_each(record, attribute, value)
    if value.present?
      if !VALID_LENGTH_RANGE.include?(value.length)
        if value.length < VALID_LENGTH_RANGE.min
          record.errors.add(attribute, :bank_account_number_too_short)
        else
          record.errors.add(attribute, :bank_account_number_too_long)
        end
      end

      record.errors.add(attribute, :bank_account_number_digits_only) if value =~ /\D/
      record.errors.add(attribute, :bank_account_number_invalid_barclays_length) if value[0..1] == VALID_BARCLAYS_PREFIX && value.length != VALID_BARCLAYS_LENGTH
    end
  end
end