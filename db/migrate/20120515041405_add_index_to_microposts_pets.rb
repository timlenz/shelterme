class AddIndexToMicropostsPets < ActiveRecord::Migration
  def change
    add_index :microposts, [:pet_id, :created_at]
  end
end
