class CreateGuideLayouts < ActiveRecord::Migration
  def self.up
    create_table :guide_layouts do |t|
      t.string :name
      t.string :path
      t.boolean :public, :default => false

      t.timestamps
    end

    GuideLayout.create(:id => 1, :name => 'tiny', :path => 'tiny', :public => true)
    GuideLayout.create(:id => 2, :name => 'other1', :path => 'other1', :public => true)
    GuideLayout.create(:id => 3, :name => 'other2', :path => 'other2', :public => true)
    GuideLayout.create(:id => 4, :name => 'other3', :path => 'other3', :public => true)
    GuideLayout.create(:id => 5, :name => 'other4', :path => 'other4', :public => true)
    GuideLayout.create(:id => 6, :name => 'other5', :path => 'other5', :public => true)
    GuideLayout.create(:id => 7, :name => 'other6', :path => 'other6', :public => true)
    GuideLayout.create(:id => 8, :name => 'other7', :path => 'other7', :public => true)
  end

  def self.down
    drop_table :guide_layouts
  end
end
