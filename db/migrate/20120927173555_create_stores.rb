class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.integer :address_id
      t.integer :merchant_id
      t.timestamps
    end
  end
end
