class AddSaveBooleanToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :save_search, :boolean, default: false
  end
end
