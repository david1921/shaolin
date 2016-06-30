class RemoveQueryFromInfoRequest < ActiveRecord::Migration
  def up
    remove_column :info_requests, :query
  end

  def down
    add_column :info_requests, :query, :string
  end
end
