class AddUserToCalendars < ActiveRecord::Migration
  def self.up
    add_column :calendars, :user_id, :integer
    Calendar.update_all ["user_id = ?", 1]
  end

  def self.down
    remove_column :calendars, :user_id
  end
end
