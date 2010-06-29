class AddVotesToCalendars < ActiveRecord::Migration
  def self.up
    add_column :calendars, :votes_sum, :integer, :default => 0
    add_column :calendars, :votes_num, :integer, :default => 0
    Calendar.update_all ["votes_sum = ?", 0]
    Calendar.update_all ["votes_num = ?", 0]
  end

  def self.down
    remove_column :calendars, :votes_num
    remove_column :calendars, :votes_sum
  end
end
