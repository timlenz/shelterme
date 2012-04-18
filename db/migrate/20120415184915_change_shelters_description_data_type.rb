class ChangeSheltersDescriptionDataType < ActiveRecord::Migration
  def up
    change_table :shelters do |t|
      t.change :description, :text
    end
  end

  def down
    change_table :shelters do |t|
      t.chante :description, :string
    end
  end
end
