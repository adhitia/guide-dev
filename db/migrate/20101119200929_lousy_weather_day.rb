class LousyWeatherDay < ActiveRecord::Migration
  def self.up
    Condition.find(1).update_attributes({:full_name => "Sunny Weather Morning"})
    Condition.find(2).update_attributes({:full_name => "Lousy Weather Morning"})
    Condition.find(4).update_attributes({:full_name => "Sunny Weather Afternoon"})
    Condition.find(5).update_attributes({:full_name => "Lousy Weather Afternoon"})
    Condition.find(12).update_attributes({:full_name => "Sunny Weather Day"})
    Condition.find(13).update_attributes({:full_name => "Lousy Weather Day"})
  end

  def self.down
  end
end
