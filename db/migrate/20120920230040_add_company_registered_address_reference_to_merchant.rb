class AddCompanyRegisteredAddressReferenceToMerchant < ActiveRecord::Migration
  def change
    add_column :merchants, :company_registered_address_id, :integer, references: "address"
  end
end
