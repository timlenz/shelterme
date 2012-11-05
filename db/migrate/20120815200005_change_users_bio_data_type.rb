class ChangeUsersBioDataType < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.change :bio, :text
    end
  end

  def down
    change_table :users do |t|
      t.change :bio, :string
    end
  end
end