class ModifyCoatIndices < ActiveRecord::Migration
  def up
    remove_index :coats, [:fur_color_id, :fur_length_id]
  end

  def down
    add_index :coats, [:fur_color_id, :fur_length_id], unique: true
  end
end
