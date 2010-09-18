class SetDefaultsForAddress < ActiveRecord::Migration
  def self.up
    change_column :addresses, :lat, :float, :default => 0
    change_column :addresses, :lng, :float, :default => 0
  end

  def self.down
  end
end
