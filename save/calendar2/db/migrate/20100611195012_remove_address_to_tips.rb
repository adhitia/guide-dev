class RemoveAddressToTips < ActiveRecord::Migration
  def self.up
    remove_column :tips, :address
  end

  def self.down
    add_column :tips, :address, :string
  end
end
