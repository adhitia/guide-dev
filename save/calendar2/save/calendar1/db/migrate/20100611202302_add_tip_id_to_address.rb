class AddTipIdToAddress < ActiveRecord::Migration
  def self.up
    add_column :addresses, :tip_id, :integer
  end

  def self.down
    remove_column :addresses, :tip_id
  end
end
