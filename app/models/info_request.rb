require 'valid_email'

class InfoRequest < ActiveRecord::Base
  include Encryption::AttrEncrypted
  include Bespoke::Contact::Validation

  attr_encrypted :title, :first_name, :last_name, :business_name, :email, :additional_details, :telephone

  attr_accessible :business_name, 
                  :email, 
                  :first_name, 
                  :last_name, 
                  :title, 
                  :telephone,
                  :additional_details


  #
  # === Validations 
  #
  validate_as_bespoke_contact_title :title
  validates :first_name, :last_name, :business_name, presence: true
  validates :email, presence: true, email: true
  validates :telephone, presence: true
  validates :additional_details, presence: true, length: { :maximum => 500 }

  def valid_contact_titles
    Bespoke::Contact::TITLES
  end

end
