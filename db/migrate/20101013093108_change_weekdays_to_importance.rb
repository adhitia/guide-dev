class ChangeWeekdaysToImportance < ActiveRecord::Migration
  def self.up
    add_column :tips, :importance, :integer, :default => 0
    Tip.update_all ["importance = ?", 0]
    add_column :tips, :good_on, :string, :default => "xxxxxxx", :limit => 7
    Tip.update_all ["good_on = ?", "xxxxxxx"]

#    remove_column :tips, :weekday_id
    remove_column :calendars, :author
  end

  def self.down
    remove_column :calendars, :importance
  end
end
