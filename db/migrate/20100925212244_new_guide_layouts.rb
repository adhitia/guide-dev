class NewGuideLayouts < ActiveRecord::Migration
  def self.up
    layout = GuideLayout.find(3)
    layout.name = 'horizontal'
    layout.path = 'horizontal'
    layout.public = true
    layout.save

    layout = GuideLayout.find(4)
    layout.name = 'full'
    layout.path = 'full'
#    layout.public = true
    layout.save
  end

  def self.down
  end
end
