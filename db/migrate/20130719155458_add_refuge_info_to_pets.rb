class AddRefugeInfoToPets < ActiveRecord::Migration
  def change
    add_column :pets, :refuge_name, :string
    add_column :pets, :refuge_contact, :string
  end
end
