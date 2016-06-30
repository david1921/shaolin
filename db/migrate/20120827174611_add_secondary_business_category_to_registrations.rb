class AddSecondaryBusinessCategoryToRegistrations < ActiveRecord::Migration
  def change
  	add_column :registrations, :secondary_business_category, :string
  end
end
