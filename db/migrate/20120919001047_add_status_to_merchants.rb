class AddStatusToMerchants < ActiveRecord::Migration
  def change
    add_column :merchants, :status, :string
  end
end
