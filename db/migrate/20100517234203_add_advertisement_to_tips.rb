class AddAdvertisementToTips < ActiveRecord::Migration
  def self.up
    add_column :tips, :advertisement, :boolean
    Tip.update_all ["advertisement = ?", false]
  end

  def self.down
    remove_column :tips, :advertisement
  end
end
