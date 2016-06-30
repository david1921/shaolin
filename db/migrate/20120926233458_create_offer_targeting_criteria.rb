class CreateOfferTargetingCriteria < ActiveRecord::Migration
  def up
    create_table :offer_targeting_criteria do |t|
      t.belongs_to(:offer)
      t.string :criterion_type
      t.string :value
    end
  end

  def down
    drop_table :offer_targeting_criteria
  end
end
