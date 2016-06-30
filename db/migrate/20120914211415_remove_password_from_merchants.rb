class RemovePasswordFromMerchants < ActiveRecord::Migration
  def up
    remove_column :merchants, :password_digest
  end

  def down
    add_column :merchants, :password_digest, :string
  end
end
