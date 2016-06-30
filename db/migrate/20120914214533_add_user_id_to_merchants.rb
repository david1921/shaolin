class AddUserIdToMerchants < ActiveRecord::Migration
  def change
    add_column :merchants, :user_id, :integer
    add_index :merchants, :user_id
  end
end
