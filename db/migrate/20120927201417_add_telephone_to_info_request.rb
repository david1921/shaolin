class AddTelephoneToInfoRequest < ActiveRecord::Migration
  def change
    add_column :info_requests, :telephone, :string
  end
end
