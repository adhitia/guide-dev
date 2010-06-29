class SetDefaults < ActiveRecord::Migration
  def self.up
    change_column :tips, :view_count, :integer, :default => 0
    change_column :tips, :click_count, :integer, :default => 0
    change_column :tips, :description, :string, :default => ''
    change_column :tips, :url, :string, :default => ''
    change_column :tips, :advertisement, :boolean, :default => false

    change_column :calendars, :view_count, :integer, :default => 0
    change_column :calendars, :click_count, :integer, :default => 0
  end

  def self.down
    # You can't currently remove default values in Rails
    raise ActiveRecord::IrreversibleMigration, "Can't remove the default"
  end
end
