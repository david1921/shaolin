# encoding: utf-8
class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    valid = begin
      parsed = URI.parse(value)
      parsed.kind_of?(URI::HTTP) || parsed.kind_of?(URI::HTTPS)
    rescue URI::InvalidURIError
      false
    end
    unless valid
      record.errors.add(attribute, :url_invalid_website)
    end
  end
end

