class ChangeOffersStatusAndStepDefaults < ActiveRecord::Migration
  def up
    change_table :offers do |t|
      t.change_default :status, "draft"
      t.change_default :step, 0
    end
  end

  def down
    change_table :offers do |t|
      t.change_default :status, nil
      t.change_default :step, nil
    end
  end
end
