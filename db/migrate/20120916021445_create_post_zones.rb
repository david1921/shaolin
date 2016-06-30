class CreatePostZones < ActiveRecord::Migration
  def up
    create_table :post_zones, :id => false do |t|
      t.string :post_code, :limit => 7, :null => false
      t.string :post_town, :null => false
      t.binary :addresses
      t.timestamps
    end
    add_index :post_zones, :post_code, :unique => true
  end

  def down
    drop_table :post_zones
  end
end
