class CreateWeekdays < ActiveRecord::Migration
  def self.up
    create_table :weekdays do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :weekdays
  end
end
