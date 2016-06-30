class MerchantOwner < ActiveRecord::Base
  include Encryption::AttrEncrypted
 

  attr_encrypted  :title, :first_name, :last_name, :home_address
  attr_accessible :title, :first_name, :last_name, :home_address, :home_postal_code

  belongs_to :merchant

  validates_presence_of :first_name, :last_name

end
