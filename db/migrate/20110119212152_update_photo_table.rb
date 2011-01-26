class UpdatePhotoTable < ActiveRecord::Migration
  def self.up
    add_column :photos, :imageable_id, :integer
    add_column :photos, :imageable_type, :string

    remove_column :users, :photo_id
  end

  def self.down
  end
end
