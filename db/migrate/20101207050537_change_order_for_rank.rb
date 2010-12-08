class ChangeOrderForRank < ActiveRecord::Migration
  def self.up
    #remove_column :tips, :order
    remove_column :book_tips, :order
    add_column :book_tips, :rank, :integer
  end

  def self.down
  end
end
