class RenameTypeColumnInSpecies < ActiveRecord::Migration
  def up
    change_table :species do |t|
      t.rename :type, :name
    end
  end

  def down
    change_table :species do |t|
      t.rename :name, :type
    end
  end
end
