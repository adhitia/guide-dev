class AddActiveToAdvertisements < ActiveRecord::Migration
  def self.up
    add_column :advertisements, :active, :boolean
    Advertisement.update_all ["active = ?", true]
  end

  def self.down
    remove_column :advertisements, :active
  end
end
