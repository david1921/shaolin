class AddPolymorphicOwnerToKeyInformationAgreements < ActiveRecord::Migration
  def up
    change_table :key_information_agreements do |t|
      t.rename :merchant_id, :owner_id
      t.string :owner_type, null: false
    end
    remove_index :key_information_agreements, :merchant_id
    add_index :key_information_agreements, [:owner_type, :owner_id]

    execute "UPDATE key_information_agreements SET owner_type = 'Merchant'"
  end

  def down
    execute "DELETE FROM key_information_agreements WHERE owner_type <> 'Merchant'"

    change_table :key_information_agreements do |t|
      t.remove :owner_type
      t.rename :owner_id, :merchant_id
    end
    remove_index :key_information_agreements, [:owner_type, :owner_id]
    add_index :key_information_agreements, [:merchant_id]
  end
end
