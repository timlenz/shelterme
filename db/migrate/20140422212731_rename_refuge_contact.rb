class RenameRefugeContact < ActiveRecord::Migration
  def up
    change_table :pets do |t|
      t.rename :refuge_contact, :refuge_email
    end
  end

  def down
    change_table :pets do |t|
      t.rename :refuge_email, :refuge_contact
    end
  end
end
