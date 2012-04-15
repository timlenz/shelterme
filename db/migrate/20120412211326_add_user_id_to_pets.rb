class AddUserIdToPets < ActiveRecord::Migration
  def change
    add_column :pets, :user_id, :integer
    add_index :pets, [:user_id, :created_at]
  end
end