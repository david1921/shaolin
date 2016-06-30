class AddUuidToRegistrations < ActiveRecord::Migration
  def change
    change_table :registrations do |t|
      t.column :uuid, :string
    end
  end
end
