class AddPrimaryToPetPhoto < ActiveRecord::Migration
  def change
    add_column :pet_photos, :primary, :boolean, default: false
  end
end
