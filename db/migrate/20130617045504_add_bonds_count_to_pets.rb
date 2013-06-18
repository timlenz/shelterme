class AddBondsCountToPets < ActiveRecord::Migration
  def change
    add_column :pets, :bonds_count, :integer, default: 0, null: false
  end
end
