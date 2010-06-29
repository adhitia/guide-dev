class RemoveAddressIdFromTips < ActiveRecord::Migration
  def self.up
    remove_column :tips, :address_id
  end

  def self.down
    add_column :tips, :address_id, :integer
  end
end
