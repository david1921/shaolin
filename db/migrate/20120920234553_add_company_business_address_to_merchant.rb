class AddCompanyBusinessAddressToMerchant < ActiveRecord::Migration
  def change
    add_column :merchants, :company_business_address_id, :integer, references: "address"
  end
end
