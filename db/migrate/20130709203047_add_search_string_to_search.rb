class AddSearchStringToSearch < ActiveRecord::Migration
  def change
    add_column :searches, :search_string, :string
  end
end
