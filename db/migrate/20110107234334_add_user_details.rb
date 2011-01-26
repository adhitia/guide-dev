class AddUserDetails < ActiveRecord::Migration
  def self.up
    add_column :users, :bio, :text, :default => ''
    add_column :users, :public_email, :string
    add_column :users, :website, :string
    add_column :users, :facebook, :string
    add_column :users, :twitter, :string
    add_column :users, :photo_id, :integer
  end

  def self.down
  end
end
