class AddAddressToTips < ActiveRecord::Migration
  def self.up
    add_column :tips, :address, :string
  end

  def self.down
    remove_column :tips, :address
  end
end
