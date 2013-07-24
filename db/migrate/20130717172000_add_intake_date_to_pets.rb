class AddIntakeDateToPets < ActiveRecord::Migration
  def change
    add_column :pets, :intake_date, :datetime
  end
end
