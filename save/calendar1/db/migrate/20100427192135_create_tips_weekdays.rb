# join table
class CreateTipsWeekdays < ActiveRecord::Migration
  def self.up
    create_table :tips_weekdays, :id => false do |t|
      t.integer :tip_id
      t.integer :weekday_id
    end
  end

  def self.down
    drop_table :tips_weekdays
  end
end
