class AddUserIdToPetVideos < ActiveRecord::Migration
  def change
    add_column :pet_videos, :user_id, :integer
    add_index :pet_videos, [:user_id, :created_at]
  end
end
