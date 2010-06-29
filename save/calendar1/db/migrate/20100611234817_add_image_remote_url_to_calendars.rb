class AddImageRemoteUrlToCalendars < ActiveRecord::Migration
  def self.up
    add_column :tips, :image_remote_url, :string
  end

  def self.down
    remove_column :tips, :image_remote_url
  end
end
