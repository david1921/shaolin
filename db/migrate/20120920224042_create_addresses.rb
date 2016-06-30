class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :postcode
      t.string :address_line_1
      t.string :address_line_2
      t.string :address_line_3
      t.string :address_line_4
      t.string :address_line_5
      t.string :post_town

      t.timestamps
    end
  end
end
