class RemoveCompanyRegisteredAddressColumnsFromMerchant < ActiveRecord::Migration
  def up
    change_table :merchants do |t|
      t.remove :company_registered_post_code
      t.remove :company_registered_house_name_number
      t.remove :company_registered_address_1
      t.remove :company_registered_address_2
      t.remove :company_registered_address_3
      t.remove :company_registered_address_4
      t.remove :company_registered_address_5
    end
  end

  def down
    change_table :merchants do |t|
      t.string  :company_registered_post_code
      t.string  :company_registered_house_name_number
      t.string  :company_registered_address_1
      t.string  :company_registered_address_2
      t.string  :company_registered_address_3
      t.string  :company_registered_address_4
      t.string  :company_registered_address_5
    end
  end
end
