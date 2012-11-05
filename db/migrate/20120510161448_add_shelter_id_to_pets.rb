class AddShelterIdToPets < ActiveRecord::Migration
  def change
    add_column :pets, :shelter_id, :integer
    add_index :pets, [:shelter_id, :created_at]
  end
end
