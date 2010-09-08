class AddPublicToCalendars < ActiveRecord::Migration
  def self.up
    add_column :calendars, :public, :boolean, :default => false
    Calendar.update_all ["public = ?", true]
  end

  def self.down
    remove_column :calendars, :public
  end
end
