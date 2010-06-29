class CreateTips < ActiveRecord::Migration
  def self.up
    create_table :tips do |t|
      t.integer :condition_id
#      t.integer :day_of_week
      t.integer :calendar_id
      t.string :name
      t.string :description
      t.string :url
      t.integer :view_count
      t.integer :click_count

      t.timestamps
    end
  end

  def self.down
    drop_table :tips
  end
end
