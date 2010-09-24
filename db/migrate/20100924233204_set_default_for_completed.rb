class SetDefaultForCompleted < ActiveRecord::Migration
  def self.up
    change_column :calendars, :completed_percentage, :integer, :default => 0
  end

  def self.down
  end
end
