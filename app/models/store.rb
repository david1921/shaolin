class Store < ActiveRecord::Base
  belongs_to :merchant
  belongs_to :address, autosave: :true
  has_and_belongs_to_many :offers

  attr_accessible :name, :email_address, :opening_hours, :phone_number, :address_attributes, :address_id
  accepts_nested_attributes_for :address

  validates :name, presence: true
  validates :address, presence: true
  validates :merchant, presence: true
  validates :email_address, email: true, allow_blank: true
  validates :phone_number, landline_phone: true

end
