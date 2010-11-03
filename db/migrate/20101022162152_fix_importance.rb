class FixImportance < ActiveRecord::Migration
  def self.up
    remove_column :tips, :importance
    add_column :tips, :day, :integer, :default => 0
    add_column :tips, :rank, :integer, :default => 0
    Tip.update_all ["rank = ?", 0]
    Tip.all.each do |tip|
      tip.day = tip.weekday_id - 1
      tip.save
    end
  end

  def self.down
  end
end
