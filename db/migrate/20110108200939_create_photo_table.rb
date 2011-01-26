class CreatePhotoTable < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.string :image_file_name
      t.string :image_content_type
      t.string :image_file_size
      t.datetime :image_updated_at
      t.string :image_remote_url
      t.integer :image_width
      t.integer :image_height

      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
