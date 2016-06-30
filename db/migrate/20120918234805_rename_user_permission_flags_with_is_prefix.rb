class RenameUserPermissionFlagsWithIsPrefix < ActiveRecord::Migration
  def change
    rename_column :users, :system, :is_system
    rename_column :users, :sales, :is_sales
    rename_column :users, :merchant, :is_merchant
    rename_column :users, :admin, :is_admin
  end
end
