class CreateShelterAdmins < ActiveRecord::Migration
  def change
    create_table :shelter_admins do |t|
      t.integer :user_id
      t.integer :shelter_id

      t.timestamps
    end

      add_index :shelter_admins, :user_id
      add_index :shelter_admins, :shelter_id
      add_index :shelter_admins, [:user_id, :shelter_id], unique: true
  end
end
