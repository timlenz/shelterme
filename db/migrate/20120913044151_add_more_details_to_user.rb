class AddMoreDetailsToUser < ActiveRecord::Migration
  def change
    add_column :users, :open_value_id, :integer
    add_column :users, :plan_value_id, :integer
    add_column :users, :social_value_id, :integer
    add_column :users, :attitude_value_id, :integer
    add_column :users, :emotion_value_id, :integer
    add_column :users, :clean_value_id, :integer
    add_column :users, :energy_value_id, :integer
    add_column :users, :species_id, :integer
    
    add_index :users, :open_value_id
    add_index :users, :plan_value_id
    add_index :users, :social_value_id
    add_index :users, :attitude_value_id
    add_index :users, :emotion_value_id
    add_index :users, :clean_value_id
    add_index :users, :energy_value_id
    add_index :users, :species_id
  end
end
