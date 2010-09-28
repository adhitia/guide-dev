class AddFullGuideLayout < ActiveRecord::Migration
  def self.up
    layout = GuideLayout.find(4)
    layout.public = true
    layout.save
  end

  def self.down
  end
end
