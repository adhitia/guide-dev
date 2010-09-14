class RemoveTestLayouts < ActiveRecord::Migration
  def self.up
    g = GuideLayout.find(2);
    g.name = 'accordion'
    g.path = 'accordion'
    g.save
    
    for id in (3..8)
      g = GuideLayout.find(id)
      g.public = false
      g.save
    end
  end

  def self.down
  end
end
