class AddAdmins < ActiveRecord::Migration
  def self.up
    add_column :users, :admin, :boolean, :default => false

    # for heroku only
#    a = User.find(1)
#    a.admin = true
#    a.save!
#
#    a = User.find(2)
#    a.admin = true
#    a.save!
  end

  def self.down
  end
end
