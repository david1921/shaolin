class AddBankAddressToMerchant < ActiveRecord::Migration
  def change
    add_column :merchants, :bank_address_id, :integer, references: "address"
  end
end
