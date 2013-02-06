class ChangeCoatDetails < ActiveRecord::Migration
  def up
    add_index :coats, :secondary_color_id
    rename_index :coats, :fur_color_id, :primary_color_id
    rename_index :coats, [:fur_color_id, :fur_length_id], [:primary_color_id, :fur_length_id]
    
    change_table :coats do |t|
      t.rename :fur_color_id, :primary_color_id
      t.integer :secondary_color_id
    end
  end

  def down
    change_table :coats do |t|
      t.remove :secondary_color_id
      t.rename :primary_color_id, :fur_color_id
    end
    
    rename_index :coats, [:primary_color_id, :fur_length_id], [:fur_color_id, :fur_length_id]
    rename_index :coats, :primary_color_id, :fur_color_id
    remove_index :coats, :secondary_color_id
  end
end
