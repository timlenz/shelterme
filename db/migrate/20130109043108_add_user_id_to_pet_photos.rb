class AddUserIdToPetPhotos < ActiveRecord::Migration
  def change
    add_column :pet_photos, :user_id, :integer
    add_index :pet_photos, [:user_id, :created_at]
  end
end
