class AddImageDataToBooks < ActiveRecord::Migration
  def self.up
    Book.delete_all
    add_column :books, :image_data, :string, :limit => 10000
  end

  def self.down
  end
end
