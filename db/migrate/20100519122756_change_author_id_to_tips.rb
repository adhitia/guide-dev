class ChangeAuthorIdToTips < ActiveRecord::Migration
  def self.up
    remove_column :tips, :author_id
    add_column :tips, :author_id, :integer
    Tip.update_all ["author_id = ?", 1]
  end

  def self.down
  end
end
