class RemoveBusinessBankAddressFieldsFromMerchants < ActiveRecord::Migration
  def up
    remove_column :merchants, :business_bank_address
  end

  def down
    add_column :merchants, :business_bank_address, :string
  end
end
