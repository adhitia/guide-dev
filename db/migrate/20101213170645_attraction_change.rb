class AttractionChange < ActiveRecord::Migration
  def self.up
    change_column :attractions, :popularity, :integer, :default => 0
  end

  def self.down
  end
end
