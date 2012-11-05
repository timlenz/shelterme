class AddShelterManagerToUser < ActiveRecord::Migration
  def change
    add_column :users, :manager, :boolean, default: false
    add_column :users, :shelter_id, :integer
  end
end
