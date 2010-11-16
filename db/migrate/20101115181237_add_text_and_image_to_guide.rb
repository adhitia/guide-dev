class AddTextAndImageToGuide < ActiveRecord::Migration
  def self.up
    add_column :calendars, :description, :string, :default => ''
    add_column :calendars, :image_file_name, :string
    add_column :calendars, :image_content_type, :string
    add_column :calendars, :image_file_size, :integer
    add_column :calendars, :image_updated_at, :datetime
    add_column :calendars, :image_remote_url, :string
  end

  def self.down
  end
end
