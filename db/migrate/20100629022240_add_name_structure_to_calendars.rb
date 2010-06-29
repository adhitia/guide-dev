class AddNameStructureToCalendars < ActiveRecord::Migration
  def self.up
    add_column :calendars, :name_location, :string
    add_column :calendars, :name_target, :string
  end

  def self.down
    remove_column :calendars, :name_target
    remove_column :calendars, :name_location
  end
end
