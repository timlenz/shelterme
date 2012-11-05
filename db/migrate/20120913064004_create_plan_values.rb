class CreatePlanValues < ActiveRecord::Migration
  def change
    create_table :plan_values do |t|
      t.string :name

      t.timestamps
    end
  end
end
