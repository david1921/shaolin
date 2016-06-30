class AddSecurePasswordToMerchant < ActiveRecord::Migration
  def change
    rename_column :merchants, :password, :password_digest
  end
end
