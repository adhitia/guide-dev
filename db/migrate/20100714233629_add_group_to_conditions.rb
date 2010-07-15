class AddGroupToConditions < ActiveRecord::Migration
  def self.up
    add_column :conditions, :group, :string
  end

  def self.down
    remove_column :conditions, :group
  end
end
