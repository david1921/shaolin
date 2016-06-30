class CreateInfoRequests < ActiveRecord::Migration
  def change
    create_table :info_requests do |t|
      t.string :title
      t.string :first_name
      t.string :last_name
      t.string :business_name
      t.string :email
      t.string :telephone

      t.timestamps
    end
  end
end
