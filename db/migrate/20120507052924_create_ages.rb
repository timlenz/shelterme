class CreateAges < ActiveRecord::Migration
  def change
    create_table :ages do |t|
      t.integer :number
      t.integer :age_period_id
      t.integer :age_group_id

      t.timestamps
    end
  end
end
