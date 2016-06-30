class AddMerchantOwners < ActiveRecord::Migration
  def up
    create_table :merchant_owners, force: true do |t|
      t.integer          :merchant_id
      t.string           :first_name
      t.string           :last_name
      t.string           :home_postal_code
      t.text             :home_address
      t.datetime         :created_at
      t.datetime         :updated_at
      t.string           :title
    end
    add_index :merchant_owners, :merchant_id
  end

  def down
    drop_table :merchant_owners
  end
end
