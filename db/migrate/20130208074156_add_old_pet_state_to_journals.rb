class AddOldPetStateToJournals < ActiveRecord::Migration
  def change
    add_column :journals, :old_pet_state_id, :integer
    add_index :journals, :old_pet_state_id
  end
end
