class ChangeLocationToCalendars < ActiveRecord::Migration
  def self.up
    remove_column :calendars, :location_name
    remove_column :calendars, :location_id
    add_column :calendars, :location_id, :integer
    Calendar.update_all ["location_id = ?", 1]
  end

  def self.down
  end
end
