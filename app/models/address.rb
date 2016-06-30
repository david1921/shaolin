class Address < ActiveRecord::Base
  include Encryption::AttrEncrypted

  attr_encrypted  :address_line_1, :address_line_2, :address_line_3, :address_line_4, :address_line_5, :post_town
  attr_accessible :address_line_1, :address_line_2, :address_line_3, :address_line_4, :address_line_5, :post_town, :postcode

  validates :postcode, postcode: true, presence: true
  validates :address_line_1, presence: true
  validates :post_town, presence: true

  def to_s
    address_lines = [address_line_1, address_line_2, address_line_3, address_line_4, address_line_5]
    "#{address_lines.keep_if(&:present?).join(", ")} #{post_town} #{postcode}"
  end
end
