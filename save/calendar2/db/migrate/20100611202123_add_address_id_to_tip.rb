class AddAddressIdToTip < ActiveRecord::Migration
  def self.up
    add_column :tips, :address_id, :integer
  end

  def self.down
    remove_column :tips, :address_id
  end
end
