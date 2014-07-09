class AddAccessToShelters < ActiveRecord::Migration
  def change
    add_column :shelters, :access, :boolean, default: false
  end
end
