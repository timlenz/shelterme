class AddDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :location, :string
    add_column :users, :bio, :string
    add_column :users, :phone, :string
  end
end
