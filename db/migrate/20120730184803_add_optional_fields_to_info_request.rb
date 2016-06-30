class AddOptionalFieldsToInfoRequest < ActiveRecord::Migration
  def change
    add_column :info_requests, :query, :string
    add_column :info_requests, :business_category, :string
    add_column :info_requests, :business_sector, :string
    add_column :info_requests, :method_of_contact, :string
    add_column :info_requests, :preferred_time_of_contact, :string
  end
end
