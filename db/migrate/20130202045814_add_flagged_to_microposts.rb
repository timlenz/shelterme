class AddFlaggedToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :flagged, :boolean, default: false
  end
end
