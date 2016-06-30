class AddPositionInCompanyToInfoRequest < ActiveRecord::Migration
  def change
    add_column :info_requests, :position_in_company, :string
  end
end
