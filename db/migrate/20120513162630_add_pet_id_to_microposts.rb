class AddPetIdToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :pet_id, :integer
  end
end
