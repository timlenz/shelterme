class CreateSocialValues < ActiveRecord::Migration
  def change
    create_table :social_values do |t|
      t.string :name

      t.timestamps
    end
  end
end
