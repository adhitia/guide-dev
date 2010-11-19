class StringToText < ActiveRecord::Migration
  def self.up
    change_column :tips, :description, :text, :default => ''
    change_column :calendars, :description, :text, :default => ''
  end

  def self.down
  end
end
