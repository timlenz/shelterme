class AddMoreRefugeInfoToPets < ActiveRecord::Migration
  def change
    add_column :pets, :refuge_person, :string
    add_column :pets, :refuge_phone, :string
  end
end
