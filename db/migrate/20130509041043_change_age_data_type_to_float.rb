class ChangeAgeDataTypeToFloat < ActiveRecord::Migration
  def up
    change_table :pets do |t|
      t.change :age, :float
    end
  end

  def down
    change_table :pets do |t|
      t.change :age, :integer
    end
  end
end