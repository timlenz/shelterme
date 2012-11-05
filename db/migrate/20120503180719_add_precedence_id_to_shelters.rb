class AddPrecedenceIdToShelters < ActiveRecord::Migration
  def change
    add_column :shelters, :precedence_id, :integer, default: 1
    add_index :shelters, [:precedence_id, :created_at]
  end
end
