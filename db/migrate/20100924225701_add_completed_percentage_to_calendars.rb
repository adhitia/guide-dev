class AddCompletedPercentageToCalendars < ActiveRecord::Migration
  def self.up
    add_column :calendars, :completed_percentage, :integer
  end

  def self.down
    remove_column :calendars, :completedPercentage
  end
end
