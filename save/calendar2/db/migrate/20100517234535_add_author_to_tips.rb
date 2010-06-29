class AddAuthorToTips < ActiveRecord::Migration
  def self.up
    add_column :tips, :author_id, :boolean
    Tip.update_all ["author_id = ?", 1]
  end

  def self.down
    remove_column :tips, :author_id
  end
end
