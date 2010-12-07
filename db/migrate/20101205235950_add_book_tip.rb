class AddBookTip < ActiveRecord::Migration
  def self.up
    create_table :book_tips do |t|
      t.integer :book_id
      t.integer :tip_id
      t.integer :order

      t.integer :image_offset_x, :default => 0
      t.integer :image_offset_y, :default => 0

      t.string :name
      t.text :description
      t.string :url
      t.string :phone
      t.string :address

      t.timestamps
    end

    remove_column :books, :image_data
    Book.delete_all
  end

  def self.down
    drop_table :conditions
  end
end
