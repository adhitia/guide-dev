class AddPhoneToTips < ActiveRecord::Migration
  def self.up
    add_column :tips, :phone, :string
  end

  def self.down
    remove_column :tips, :phone
  end
end
