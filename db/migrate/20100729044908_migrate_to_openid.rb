class MigrateToOpenid < ActiveRecord::Migration
  def self.up
    remove_column :users, :password
    add_column :users, :registration_complete, :boolean
    User.update_all ["registration_complete = ?", true]
  end

  def self.down
  end
end
