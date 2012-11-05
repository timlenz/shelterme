class CreatePetStates < ActiveRecord::Migration
  def change
    create_table :pet_states do |t|
      t.string :status

      t.timestamps
    end
  end
end
