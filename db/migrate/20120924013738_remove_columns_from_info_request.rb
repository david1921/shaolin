class RemoveColumnsFromInfoRequest < ActiveRecord::Migration
  def up
    remove_column :info_requests, :telephone
    remove_column :info_requests, :business_category
    remove_column :info_requests, :method_of_contact
    remove_column :info_requests, :preferred_time_of_contact
    remove_column :info_requests, :business_sector
    remove_column :info_requests, :position_in_company
    add_column    :info_requests, :additional_details, :string
  end

  def down
    add_column    :info_requests, :telephone, :string
    add_column    :info_requests, :business_category, :string
    add_column    :info_requests, :method_of_contact, :string
    add_column    :info_requests, :preferred_time_of_contact, :string
    add_column    :info_requests, :business_sector, :string
    add_column    :info_requests, :position_in_company, :string
    remove_column :info_requests, :additional_details
  end
end