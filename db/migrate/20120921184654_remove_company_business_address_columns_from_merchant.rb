class RemoveCompanyBusinessAddressColumnsFromMerchant < ActiveRecord::Migration
  def up
    change_table :merchants do |t|
      t.remove :address_postcode
      t.remove :address_premises_name
      t.remove :address_premises_number
      t.remove :company_business_address_address_1
      t.remove :company_business_address_address_2
      t.remove :company_business_address_address_3
      t.remove :company_business_address_address_4
      t.remove :company_business_address_address_5
    end
  end

  def down
    change_table :merchants do |t|
      t.string :address_postcode
      t.string :address_premises_name
      t.string :address_premises_number
      t.string :company_business_address_address_1
      t.string :company_business_address_address_2
      t.string :company_business_address_address_3
      t.string :company_business_address_address_4
      t.string :company_business_address_address_5
    end
  end
end
