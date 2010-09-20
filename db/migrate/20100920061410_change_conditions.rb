class ChangeConditions < ActiveRecord::Migration
  def self.up
    (12..15).each do |id|
      c = Condition.find(id)
      c.group = nil
      c.save
    end
  end

  def self.down
  end
end
